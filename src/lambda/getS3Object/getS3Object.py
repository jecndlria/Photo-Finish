import json
import boto3
import base64

def lambda_handler(event, context):
    s3 = boto3.client('s3')

    bucket_name = 'photo-finish-bucket'
    object_key = event['object_key']
    image_url = f'https://{bucket_name}.s3.amazonaws.com/{object_key}'

    try:
        response = s3.get_object(Bucket=bucket_name, Key=object_key)
        print("Object Exists")
        # Processing can be done here

        return {
            'statusCode' : 200,
            'image_url': image_url,
        }
    except Exception as e:
        print("Error:", e)
        return {
            'statusCode': 500,
            'body': str(e)
        }
