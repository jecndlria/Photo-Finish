import logging
from pprint import pprint
import boto3
from botocore.exceptions import ClientError
from botocore.vendored import requests
import pymysql
import password
import json
from datetime import datetime

rds_host = password.rds_host
name = password.db_username
dbpassw = password.db_password
db_name = password.db_name
userpool_id = password.userpool

def lambda_handler(event, context): #event parameter should be triggered by s3 object creation
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    rekognition = boto3.client('rekognition')
    s3 = boto3.client('s3')
    sns = boto3.client('sns')
    bucket_name = 'photo-finish-bucket'

    points_for_photo = 0
    labels_list = []
    confidence_list = []
    try:
        object_key = event["Name"]
        username = event["Username"]
        logger.info("Calling rekognition.detect_labels function")
        response = rekognition.detect_labels(
            Image={
                'S3Object': {
                    'Bucket': bucket_name,
                    'Name': object_key
                }
            }
        )
        logger.info("Rekognition.detect_labels function executed successfully")

        #retrieve the prompt object from the database
        prompt_object = get_prompt()
        print(prompt_object)
        confidence_of_obj = None

        for label in response['Labels']:
            if label['Name'] == prompt_object:
                confidence_of_obj = label['Confidence']
                logger.info(f"Object of the day: {prompt_object}")
                logger.info(f"Confidence of the object of the day: {confidence_of_obj}")
                break
            else: 
                logger.info(f"Object not found in image")
        
        #if the object is found then it will publish an sns message 
        if confidence_of_obj > 50:
            try:
                sns_topic_arn = 'arn:aws:sns:us-west-1:058264131615:prompt_check'
                sns_response = sns.publish(
                    TopicArn=sns_topic_arn,
                    Message=f"Detected label: {prompt_object}, Confidence level: {confidence_of_obj}",
                    Subject="Prompt Object Found"
                )
                if sns_response['ResponseMetadata']['HTTPStatusCode'] == 200:
                    logger.info("Message published to SNS topic successfully.")
                else:
                    logger.error("Failed to publish message to SNS topic.")
            except ClientError as e:
                logger.error(f"Error publishing message to SNS topic: {e}")                  
        #if confidence level above a 50% threshold then points awarded -> update database
        if confidence_of_obj > 50:
            points_for_photo += int(confidence_of_obj)
            update_points(event['Username'], points_for_photo)
            return {
                'statusCode': 200,
                'body': json.dumps('Points updated successfully!'),
                'points': points_for_photo
            }

        return {
            'statusCode': 500,
            'body': json.dumps('An unexpected error occurred!'),
            'points': 0
        }       

    except KeyError as e:
        logger.error(f"KeyError: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps('An unexpected error occurred!'),
            'points': 0
        } 
    except ClientError as e:
        logger.error(f"Error detecting labels: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps('An unexpected error occurred!'),
            'points': 0
        } 
    except Exception as e:
        logger.error(f"An unexpected error occurred: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps('An unexpected error occurred!'),
            'points': 0
        } 
        
def get_prompt():
    try:
        conn = pymysql.connect(host=rds_host, user=name, passwd=dbpassw, db='photofinish', connect_timeout=15)
        curr = conn.cursor()
        sql = f"""SELECT prompt FROM daily_prompts
            ORDER BY date DESC
            LIMIT 1;
            """
        print(sql)
        curr.execute(sql)
        result = curr.fetchone()
        print(result[0])
    except (Exception, pymysql.DatabaseError) as error:
        print(error)
        print('There was an error.')
        error_message = str(error)
        return {
            'statusCode': 500,
            'body': json.dumps({'error': error_message}),
            'points': 0
        }
    finally:
        conn.close()
    return result[0]

def update_points(username, points_for_photo):
    try:
        conn = pymysql.connect(host=rds_host, user=name, passwd=dbpassw, db='photofinish', connect_timeout=15)
        curr = conn.cursor()
        sql = f"""SELECT pointscount FROM user_accounts WHERE username = '{username}'
        """
        curr.execute(sql)
        points = curr.fetchone()[0]
        print(points)
        points_total = points + points_for_photo
        sql2 = f"""UPDATE user_accounts SET pointscount = {points_total} WHERE username = '{username}'
        """
        curr.execute(sql2)
        conn.commit()
        print('Points have been updated!')
    except (Exception, pymysql.DatabaseError) as error:
        print(error)
        print('There was an error.')
        error_message = str(error)
        return {
            'statusCode': 500,
            'body': json.dumps({'error': error_message}),
            'points': 0
        }
    finally:
        conn.close()
    return 1