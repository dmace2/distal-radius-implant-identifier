import psycopg2
from psycopg2.extras import RealDictCursor
import urllib.parse as urlparse
import os
from fastapi import HTTPException


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

        print('db connection:', self.con)

    def validateSQLParam(self, param):
        if not all([command not in param.lower() for command in ["select", "delete", "update", "drop", "join"]]):
            raise HTTPException(status_code=400, detail="Invalid company name")

    def fixCompanyName(self, company):
        return " ".join(company.split("_"))

    def get_implants(self, company):
        self.validateSQLParam(company)
        full_company = self.fixCompanyName(company)
        cur = self.con.cursor(cursor_factory=RealDictCursor)
        print("Testing")

        # get list of guides
        get_guides = f"""
            select * from "companyGuides"
            where company = '{full_company}'
        """
        print(get_guides)
        cur.execute(get_guides)
        guides = cur.fetchall()
        print("GUIDES")
        print(guides)

        print("___________________________")

        # get list of implants
        get_implants = f"""
            select * from "companyImplants"
            where "assocCompany" = '{full_company}'
        """
        cur.execute(get_implants)
        implants = cur.fetchall()
        print(implants)

        print("___________________________")

        # format implants into dict
        implantDict = {}
        for row in implants:
            print(row)
            # easy way to keep track of whether I've seen this implant before
            if row['implantName'] not in implantDict:
                implantDict[row['implantName']] = {
                    "implantName": row['implantName'],
                    "implantURL": row['imageURL'],
                    "guides": []
                }

        # format guides into implant dict
        outside_guides = []
        for row in guides:
            if row["companySpecific"] == True:
                outside_guides.append({
                    "type": row['guideType'],
                    "urlString": row['URL']
                })
            else:
                implantDict[row['implant']]['guides'].append({
                    "type": row['guideType'],
                    "urlString": row['URL']
                })

        # # just return the implants themselves
        return (list(implantDict.values()), outside_guides)

    def get_implant_images(self, company):
        self.validateSQLParam(company)
        cur = self.con.cursor(cursor_factory=RealDictCursor)

        # get list of tools
        cur.execute(f"""
            select implants."implantName", implants."imageURL" as "implantURL"
            from implants
            where implants."assocCompany"='{company}'""")
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
