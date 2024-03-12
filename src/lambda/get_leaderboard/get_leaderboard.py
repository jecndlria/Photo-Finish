import boto3
from botocore.exceptions import ClientError

def get_following(username):
    following = [] #query to retrieve all the usernames that the user is following
    return following

def get_leaderboard_data(username):
    leaderboard_data = [] #query to retrieve all usernames and with their associated points
    return leaderboard_data

def lambda_handler(event, context):
    username = event.get("username")

    #make sure userid is valid
    if not username:
        return 
        {
            "statusCode": 400, 
            "body": "Invalid input. Missing username."
        }

    try:
        #get the list of users following
        following = get_following(username)
        #get the leaderboard data
        leaderboard_data = get_leaderboard_data(username)
        filtered_leaderboard = [] #query to filter the leaderboard based on the following list usernames

        response = {
            "statusCode": 200,
            "body": 
            {
                "leaderboard": filtered_leaderboard
            }
        }
        return response

    except ClientError as e:
        return 
        {
            "statusCode": 500, 
            "body": f"Database error: {str(e)}"
        }

    except Exception as e:
        return 
        {
            "statusCode": 500, 
            "body": f"Unexpected error: {str(e)}"
        }
