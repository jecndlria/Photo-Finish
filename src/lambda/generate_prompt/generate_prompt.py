import json
import boto3
import mysql.connector
import random
import csv

def lambda_handler(event, context):
    users = get_users_from_mysql()

    for user in users:
        send_prompt(user['user_id'])

#def get_users_from_mysql():
#  mysql query to get all users

def choose_object(csv_file_path):
    try:
        with open(csv_file_path, newline='', encoding='utf-8') as csvfile:
            objects = list(csv.reader(csvfile))
            rand_obj = random.choice(objects)[0] #only 1 column

            return rand_obj
    except Exception as e:
        print(f"Error reading CSV file: {e}")

def send_prompt_to_user(user_id):
    obj_of_the_day = choose_object('Photo-Finish\src\lambda\generate_prompt\AmazonRekognitionAllLabels_v3.0.csv') #chooses an object from this csv

    prompt = f"Photo object of the day: {obj_of_the_day}"
    print(f"Sending prompt to user {user_id}: {prompt}")


