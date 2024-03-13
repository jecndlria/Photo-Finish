import logging
from pprint import pprint
import boto3
from botocore.exceptions import ClientError
from botocore.vendored import requests

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

        #for label in response['Labels']:
            #labels_list.append(label['Name'])
            #confidence_list.append(label['Confidence'])

        #print("Labels:", labels_list)
        #print("Confidence Levels:", confidence_list)

        #TODO: retrieve the prompt object from the database
        prompt_object = "Apple"
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
        if confidence_of_obj is not None and confidence_of_obj > 0:
            sns_topic_arn = 'arn:aws:sns:us-west-1:058264131615:prompt_check'
            sns.publish(
                TopicArn=sns_topic_arn,
                Message=f"Detected label: {prompt_object}, Confidence level: {confidence_of_obj}",
                Subject="Prompt Object Found"
            )
        #if confidence level above a 50% threshold then points awarded -> update database
        if confidence_of_obj is not None and confidence_of_obj > 0:
            points_for_photo += 3
            #TODO:update database with points count

    except KeyError as e:
        logger.error(f"KeyError: {e}")
    except ClientError as e:
        logger.error(f"Error detecting labels: {e}")
    except Exception as e:
        logger.error(f"An unexpected error occurred: {e}")
