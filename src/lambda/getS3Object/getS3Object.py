import json
import boto3

def getS3Object(event, context):
    s3 = boto3.client('s3')

    bucket_name = 'photo-finish-bucket'
    object_key = 'test.png'

    try:
        response = s3.get_object(Bucket=bucket_name, Key=object_key)
        object_content = response['Body'].read()

        # Processing can be done here

        return {
            'statusCode' : 200,
            'body': image_content,
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
