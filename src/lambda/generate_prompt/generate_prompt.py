import json
import boto3
import random
import csv

def lambda_handler(event, context):
    prompt = choose_object('Photo-Finish\src\lambda\AmazonRekognitionAllLabels_v3.0.csv')
    #TODO: store prompt into the database
    print(f"Object of the day: {prompt}")

def choose_object(csv_file_path):
    try:
        with open(csv_file_path, newline='', encoding='utf-8') as csvfile:
            objects = list(csv.reader(csvfile))
            rand_obj = random.choice(objects)[0] # only 1 column

            return rand_obj
    except Exception as e:
        print(f"Error reading CSV file: {e}")



