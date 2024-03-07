import pymysql
import password

rds_host = password.rds_host
name = password.pf_admin
password = password.db_password
db_name = password.db_name
userpool_id = password.userpool

def lambda_handler(event, context):
    try:
        conn = pymysql.connect(host=rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
        cur = conn.cursor()
        sql = f"""
        SELECT * FROM user_accounts
        """
        cur.execute(sql)
        results = cur.fetchall()
        return results
    except (Exception, pymysql.DatabaseError) as error:
        print(error)
