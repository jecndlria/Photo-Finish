import json
import boto3

def lambda_handler(event, context):
    client = boto3.client('cognito-idp')
    return {
        'statusCode': 200
        'body': 'Success'
    }
