import boto3
from botocore.exceptions import ClientError

def get_following(user_id):
    following = [] #query to retrieve all the userids that the user is following
    return following

def get_leaderboard_data(user_id):
    leaderboard_data = [] #query to retrieve all user ids and with their associated points
    return leaderboard_data

def lambda_handler(event, context):
    user_id = event.get("userId")

    #make sure userid is valid
    if not user_id:
        return 
        {
            "statusCode": 400, 
            "body": "Invalid input. Missing userId."
        }

    try:
        #get the list of users following
        following = get_following(user_id)
        #get the leaderboard data
        leaderboard_data = get_leaderboard_data(user_id)
        #filter the leaderboard based on the following list
        filtered_leaderboard = [entry for entry in leaderboard_data if entry["userId"] in following_list]

        # Prepare response
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
