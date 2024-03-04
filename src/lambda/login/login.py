import pymysql
import boto3
import password

rds_host = password.rds_host
name = password.pf_admin
password = password.db_password
db_name = password.db_name
userpool_id = password.userpool

def lambda_handler(event, context): # input: username and password
  client = boto3.client('cognito-idp')
  user = event['username']
  passw = event['password']
  try:
    response = client.admin_get_user(UserPoolId=userpool_id, Username=user)
    
  except Exception as e:
    print(e)
  return {
    "status": 200,
    "body": "Hello!",
  }