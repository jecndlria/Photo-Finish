import logging
from pprint import pprint
import boto3
from botocore.exceptions import ClientError
import requests

from generate_prompt import choose_object #cam i do thhis..

def lambda_handler(event, context): #event parameter should be triggered by s3
    rekognition = boto3.client('rekognition')
    s3 = boto3.client('s3')
    sns = boto3.client('sns')

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

        #for label in response['Labels']:
            #labels_list.append(label['Name'])
            #confidence_list.append(label['Confidence'])

        #print("Labels:", labels_list)
        #print("Confidence Levels:", confidence_list)

        #TODO: UM does this make sure that its the same object generated from the generate_prompt????? i am so bad at coding
        prompt_object = choose_object('Photo-Finish\src\lambda\AmazonRekognitionAllLabels_v3.0.csv')
        confidence_of_obj = None

        for label in response['Labels']:
            if label['Name'] == prompt_object:
                confidence_of_obj = label['Confidence']
                print(f"Object of the day: {prompt_object}")
                print(f"Confidence of the object of the day: {confidence_of_obj}")
            else:
                print(f"Object not found in image")
        
        #if the object is found then it will publish an sns message 
        if prompt_object in response['Labels']:
            sns_topic_arn = 'arn:aws:sns:us-west-1:058264131615:prompt_check'
            sns.publish(
                TopicArn=sns_topic_arn,
                Message=f"Detected label: {prompt_object}, Confidence level: {confidence_of_obj}",
                Subject="Prompt Object Found"
            )
            break

    except ClientError:
        logger.info("Couldn't detect labels in %s.", self.object_key)
    except ValueError as ve: # if s3 bucket or object key info is not in the event
        print(f"ValueError: {ve}")
    except Exception as e: #handle other exceptions as needed
        print(f"An unexpected error occurred: {e}")
    
