import json
import boto3
import random
import csv
import pymysql
import password
from datetime import datetime

rds_host = password.rds_host
name = password.db_username
dbpassw = password.db_password
db_name = password.db_name
userpool_id = password.userpool

def lambda_handler(event, context):
    prompt = choose_object('AmazonRekognitionAllLabels_v3.0.csv')
    print(f"Object of the day: {prompt}")
    try:
        conn = pymysql.connect(host=rds_host, user=name, passwd=dbpassw, db='photofinish', connect_timeout=15)
        curr = conn.cursor()
        sql = f"""
        INSERT INTO daily_prompts (
            prompt
        ) VALUES(
            '{prompt}'
        )
        """
        print(sql)
        curr.execute(sql)
        conn.commit()
    finally:
        conn.close()
    return {
        'statusCode': 200,
        'body': 'Success!'
    }

def choose_object(csv_file_path):
    try:
        with open(csv_file_path, newline='', encoding='utf-8') as csvfile:
            objects = list(csv.reader(csvfile))
            rand_obj = random.choice(objects)[0] # only 1 column
            return rand_obj
    except Exception as e:
        print(f"Error reading CSV file: {e}")
