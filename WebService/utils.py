import psycopg2
from psycopg2.extras import RealDictCursor
import urllib.parse as urlparse
import os


def validateSQLParam(param):
    assert all([command not in param.lower()
               for command in ["select", "delete", "update", "drop", "join"]])


class DBService:

    def __init__(self):
        url = urlparse.urlparse(os.environ['DATABASE_URL'])
        dbname = url.path[1:]
        user = url.username
        password = url.password
        host = url.hostname
        port = url.port

        self.con = psycopg2.connect(
            dbname=dbname,
            user=user,
            password=password,
            host=host,
            port=port
        )

        print(self.con)

    def get_implants(self, company):
        validateSQLParam(company)
        cur = self.con.cursor(cursor_factory=RealDictCursor)
        # get list of tools
        cur.execute(f"""
            select implant, implants."imageURL" as "implantURL", tools."toolName", tools."imageURL" as "toolURL", implants."techniqueGuide"
            from implants left outer join tools on (implants."implantName" = tools."implant")
            where implants.company='{company}'""")
        implants = cur.fetchall()

        # format implants into dict
        implantDict = {}
        for row in implants:
            print(row)
            # easy way to keep track of whether I've seen this implant before
            if row['implant'] not in implantDict:
                implantDict[row['implant']] = {
                    "implantName": row['implant'],
                    "implantURL": row['implantURL'],
                    "techniqueGuide": row['techniqueGuide'],
                    "tools": []
                }
            implantDict[row['implant']]['tools'].append({
                "toolName": row['toolName'],
                "toolURL": row['toolURL']
            })

        # just return the implants themselves
        return list(implantDict.values())

    def get_implant_images(self, company):
        validateSQLParam(company)
        cur = self.con.cursor(cursor_factory=RealDictCursor)

        # get list of tools
        cur.execute(f"""
            select implants."implantName", implants."imageURL" as "implantURL"
            from implants
            where implants.company='{company}'""")
        implants = cur.fetchall()

        print(implants)

        # format implants into dict
        images = []
        for row in implants:
            if row['implantURL'] is not None:
                images.append({
                    "implantName": row['implantName'],
                    "imageURL": row['implantURL']
                })

        # just return the implants themselves
        return images


if __name__ == "__main__":
    db = DBService()
