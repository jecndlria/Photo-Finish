import json
import boto3

user_pool_id = "hard coded value for testing, check aws for value : )"

def lambda_handler(event, context):
    """
    Syntax for getting a username from an event (I think, no way to test yet)
    user_pool_id = event['user_pool_id']
    client_id = event['callerContext']['clientId']
    username = event['username']
    """
    cognito_client = boto3.client('cognito-idp')
    try:
        response = cognito_client.admin_get_user(UserPoolId=user_pool_id, Username="testuser")
        user_attributes = response['UserAttributes']
        #for attribute in user_attributes:
        #    if attribute['Name'] == 'email':
        return {
            'statusCode': 200,
            'body': json.dumps({
                    'username': response['Username']
                    })
                }
        return {
            'statusCode': 404,
            'body': json.dumps({
                    'message': 'Username attribute not found for the user'
                })
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Error retrieving username: {}'.format(str(e))
                })
        }

