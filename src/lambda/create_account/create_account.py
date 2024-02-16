import json
import boto3
import pymysql
import sys

REGION = 'us-west-1'
rds_host = ""
name = "pf_admin"
password = ""
db_name = "pf_database"


def lambda_handler(event, context):
    client = boto3.client('cognito-idp')
    user = event['request']['userAttributes']
    user_display_name = user["name"]
    user_handle = user["preferred_username"]
    user_email = user["email"]
    user_cognito_id = user["sub"]
    try:
        conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
        cur = conn.cursor()
        sql = f"""
        INSERT INTO users (
            display_name,
            handle,
            email,
            cognito_user_id
        ) VALUES(
            '{user_display_name}',
            '{user_handle}',
            '{user_email}',
            '{user_cognito_id}'
        )
        """
        print(sql)
        cur.execute(sql)
        conn.commit() 

    except (Exception, pymysql.DatabaseError) as error:
        print(error)

    finally:
        if conn is not None:
            cur.close()
            conn.close()
            print('Database connection closed.')

    return {
        'statusCode': 200,
        'body': 'Success'
    }
