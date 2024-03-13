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
    try:
        print('hi')
        conn = pymysql.connect(host=rds_host, user=name, passwd=dbpassw, db='photofinish', connect_timeout=15)
        print("connection")
        cur = conn.cursor()
        print('cursor')
        username = event['username']
        sql = "SELECT password FROM user_accounts WHERE username = \"" + username + "\""
        print(sql)
        cur.execute(sql)
        result = cur.fetchone()
        print(result)
        print(result[0])
        pass_compare = event['password']
        if result:
            if pass_compare == result[0]: # result is a list of tuples
                print('Passwords match!')
                return {
                    'statusCode': 200,
                    'body': 'Success!'
                }
            else: 
                print("Password is incorrect.")
                return {
                    'statusCode': 300,
                    'body': 'Incorrect password!'
                }
        else:
            print("Account username not found.")
            return {
                'statusCode': 400,
                'body': 'Unknown username!'
            }
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