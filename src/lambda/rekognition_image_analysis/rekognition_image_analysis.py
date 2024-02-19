import logging
from pprint import pprint
import boto3
from botocore.exceptions import ClientError
import requests

def lambda_handler(event, context): #event parameter should be triggered by s3
    rekognition = boto3.client('rekognition')
    s3 = boto3.client('s3')
    labels_list = []
    confidence_list = []
    try:
        bucket_name = event['Records'][0]['s3']['bucket']['name']
        object_key = event['Records'][0]['s3']['object']['key']
        response = rekognition.detect_labels(
    Image={
        'S3Object': {
            'Bucket': bucket_name,
            'Name': object_key
        }
        }
        )
        for object in response['Objects']:
            object_list.append(object['Name'])
            confidence_list.append(object['Confidence'])
            print("Objects:", objects_list)
            print("Confidence Levels:", confidence_list)
    except ClientError:
        logger.info("Couldn't detect labels in %s.", self.object_key)
    except ValueError as ve: # if s3 bucket or object key info is not in the event
        print(f"ValueError: {ve}")
    except Exception as e: #handle other exceptions as needed
        print(f"An unexpected error occurred: {e}")