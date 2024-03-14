import json
import boto3
import base64
import password
import pymysql

rds_host = password.rds_host
name = password.db_username
dbpassw = password.db_password
db_name = password.db_name
userpool_id = password.userpool

def lambda_handler(event, context):
    s3 = boto3.client('s3')

    bucket_name = 'photo-finish-bucket'
    object_key = event['object_key']
    image_url = f'https://{bucket_name}.s3.amazonaws.com/{object_key}'
    username = event['username']
    points_for_picture = event['points']
    
    #print(f"Object of the day: {prompt}")
    try:
        conn = pymysql.connect(host=rds_host, user=name, passwd=dbpassw, db='photofinish', connect_timeout=15)
        curr = conn.cursor()
        sql = f"""
        SELECT * FROM daily_prompts WHERE DATE(date) = CURDATE() LIMIT 1
        """
        print(sql)
        curr.execute(sql)
        conn.commit()
        result = curr.fetchall()  # Fetch all the results
        if result is None:
            raise ValueError("No entries found for today's date.")
        else:
            print(result)  # Print the result
        prompt = result[0][0]
        print("Prompt", prompt)
        sql = f"""
        INSERT INTO daily_photos (
            photourl,
            username,
            prompt,
            score
        ) VALUES(
            '{image_url}',
            '{username}',
            '{prompt}',
            {points_for_picture}
        )
        """
        print(sql)
        curr.execute(sql)
        conn.commit()
        # Fetch the new photo entry if needed (optional)
        new_photo_query = "SELECT * FROM daily_photos WHERE photoid = LAST_INSERT_ID()"
        curr.execute(new_photo_query)
        new_photo_result = curr.fetchone()
        print(new_photo_result)  # This will print the newly inserted photo details


    except Exception as e:
        print("Error:", e)
        return {
            'statusCode': 500,
            'body': str(e)
        }
    finally:
        conn.close()
    return {
        'statusCode': 200,
        'body': 'Success!'
    }