import pymysql
import password
import json
from datetime import datetime

rds_host = password.rds_host
name = password.db_username
dbpassw = password.db_password
db_name = password.db_name
userpool_id = password.userpool

def lambda_handler(event, context):
    current_user = event['username']
    friend_to_add = event['friend']
    try:
        conn = pymysql.connect(host=rds_host, user=name, passwd=dbpassw, db='photofinish', connect_timeout=15)
        curr = conn.cursor()
        before = f"""
        SELECT * WHERE username = '{current_user}' AND friend = '{friend_to_add}'
        """
        sql = f"""
        INSERT INTO friends (
            username,
            friend
        ) VALUES(
            '{current_user}',
            '{friend_to_add}'
        )
        """
        print(sql)
        curr.execute(sql)
        conn.commit()
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
        'body': 'Success!'
    }
