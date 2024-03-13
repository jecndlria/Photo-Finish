import json
import boto3
import pymysql
import sys
import password # password file with all aws credentials 

REGION = 'us-west-1b'
rds_host = password.rds_host
name = password.db_username
passw = password.db_password
db_name = password.db_name
userpool_id = password.userpool

def lambda_handler(event, context): # im assuming here that the new user's information will be passed in event
    print('function is starting up')
    client = boto3.client('cognito-idp')
    print('created cognito client')
    if len(event['username']) < 5:
        raise Exception("Cannot register users with username less than the minimum length of 5")
        return event
    print('username is longer than 5!')
    try:
        print('pls')
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
        print('created user!')
    except Exception as e:
        print(e)
        print('Exception raised')
        error_message = str(e)
        return {
            'statusCode': 500,
            'body': json.dumps({'error': error_message})
        }

    user = response['User']['Attributes']
    user_display_name = response['User']["Username"]
    user_email = next((attr["Value"] for attr in user if attr["Name"] == "email"), None)
    user_cognito_id = next((attr["Value"] for attr in user if attr["Name"] == "sub"), None) # generated cognito id
    created_passw = event['password']
    print('trying to connect...')
    try:
        conn = pymysql.connect(host=rds_host, user=name, password=passw, database='photofinish', connect_timeout=5)
        print('connection made!')
        cur = conn.cursor()
        sql = f"""
        INSERT INTO user_accounts (
            username,
            email,
            cognito_userid,
            password
        ) VALUES(
            '{user_display_name}',
            '{user_email}',
            '{user_cognito_id}',
            '{created_passw}'
        )
        """
        print(sql)
        cur.execute(sql)
        conn.commit() 

    except (Exception, pymysql.DatabaseError) as error:
        print(error)
        error_message = str(error)
        return {
            'statusCode': 500,
            'body': json.dumps({'error': error_message})
        }


    finally:
        if conn is not None:
            cur.close()
            conn.close()
            print('Database connection closed.')

    return {
        'statusCode': 200,
        'body': 'Success'
    }
