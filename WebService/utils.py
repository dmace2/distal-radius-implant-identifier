import psycopg2
from psycopg2.extras import RealDictCursor
import urllib.parse as urlparse
import os

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
        cur = self.con.cursor(cursor_factory=RealDictCursor)
        
        # get list of tools
        cur.execute(f"""
            select implant, implants."imageURL" as "implantURL", tools."toolName", tools."imageURL" as "toolURL", implants."techniqueGuide"
            from implants left outer join tools on (implants."implantName" = tools."implant" and implants."company" = tools."company")
            where implants.company='{company}'""")
        implants = cur.fetchall()
        
        # format implants into dict
        implantDict = {}
        for row in implants:
            print(row)
            if row['implant'] not in implantDict: # easy way to keep track of whether I've seen this implant before
                implantDict[row['implant']] = {
                    "implantName" : row['implant'],
                    "implantURL" : row['implantURL'],
                    "techniqueGuide" : row['techniqueGuide'],
                    "tools" : []
                }
            implantDict[row['implant']]['tools'].append({
                "toolName" : row['toolName'],
                "toolURL" : row['toolURL']
            })
        
        # just return the implants themselves 
        return list(implantDict.values())
        
        
if __name__ == "__main__":
    db = DBService()
