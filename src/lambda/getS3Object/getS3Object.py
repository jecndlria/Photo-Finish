import json
import boto3
import base64

def lambda_handler(event, context):
    s3 = boto3.client('s3')

    bucket_name = 'photo-finish-bucket'
    object_key = event['object_key']

    try:
        response = s3.get_object(Bucket=bucket_name, Key=object_key)
        image_content = response['Body'].read()
        encoded_image = base64.b64encode(image_content).decode('utf-8')

        # Processing can be done here

        return {
            'statusCode' : 200,
            'body': encoded_image,
            'isBase64Encoded': True,
            'headers': {
                'Content-Type': 'image/png'
            }
        }
    except Exception as e:
        print("Error:", e)
        return {
            'statusCode': 500,
            'body': 'Error retrieving image from S3'
        }
