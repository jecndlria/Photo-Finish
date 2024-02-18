import json
import boto3
import pymysql
import sys
import password # password file with all aws credentials 

REGION = 'us-west-1b'
rds_host = password.rds_host
name = password.pf_admin
password = password.db_password
db_name = password.db_name
userpool_id = ""

def lambda_handler(event, context): # im assuming here that the new user's information will be passed in event
    client = boto3.client('cognito-idp')
    try:
        response = client.admin_create_user(
            UserPoolId=userpool_id, 
            Username=event['username'],
            UserAttributes=[
                {
                    "Name": "name",
                    "Value": event['name']
                },
                {
                    "Name": "email",
                    "Value": event['email']
                }
            ],
            TemporaryPassword=event['password']
            )
    except Exception as e:
        print(e)

    user = response['User']['Attributes']
    user_display_name = response["Username"]
    user_email = next((attr["Value"] for attr in user if attr["Name"] == "email"), None)
    user_cognito_id = next((attr["Value"] for attr in user if attr["Name"] == "sub"), None) # generated cognito id
    try:
        conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
        cur = conn.cursor()
        sql = f"""
        INSERT INTO user_accounts (
            username,
            email,
            cognito_userid
        ) VALUES(
            '{user_display_name}',
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
