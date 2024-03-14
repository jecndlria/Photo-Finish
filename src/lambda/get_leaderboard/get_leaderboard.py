import pymysql
import password
import json

rds_host = password.rds_host
name = password.db_username
dbpassw = password.db_password
db_name = password.db_name
userpool_id = password.userpool

def lambda_handler(event,context):
    username = event['username']
    data = {}
    try:
        conn = pymysql.connect(host=rds_host, user=name, passwd=dbpassw, db='photofinish', connect_timeout=15)
        curr = conn.cursor()
        sql = f"""SELECT ua.username, ua.pointscount
                FROM user_accounts ua
                JOIN friends f ON ua.username = f.friend
                WHERE f.username = '{username}'
                """
        curr.execute(sql)
        result = curr.fetchall()
        for x in range(len(result)):
            data[result[x][0]] = result[x][1]
        print(data)
    except (Exception, pymysql.DatabaseError) as error:
        print(error)
        print('There was an error.')
        error_message = str(error)
        return {
            'statusCode': 500,
            'body': json.dumps({'error': error_message})
        }
    finally:
        conn.close()
    return {
        'statusCode': 200,
        'body': "Success",
        'payload': data
    }