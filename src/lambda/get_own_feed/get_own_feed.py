import pymysql
import password
import json
import boto3

rds_host = password.rds_host
name = password.db_username
dbpassw = password.db_password
db_name = password.db_name
userpool_id = password.userpool

def lambda_handler(event, context):
  username = event['username']
  data = {}
  try:
    conn = pymysql.connect(host=rds_host, user=name, passwd=dbpassw, db='photofinish', connect_timeout=15)
    curr = conn.cursor()
    sql = f"""
      SELECT dp.photourl
      FROM daily_photos dp
      WHERE dp.username = '{username}'
    """ 
    curr.execute(sql)
    print("why?")
    result = curr.fetchall()
    if not result:
      raise ValueError(f"No photos found for friends of the user {username}.")
    for x in range(len(result)):
      data[f"photo{x}"] = result[x][0]
    print(data)
  except (Exception, pymysql.DatabaseError) as error:
    print(error)
    print('There was an error.')
    error_message = str(error)
    return {
        'statusCode': 500,
        'body': json.dumps({'error': error_message})
    }
  finally:
    conn.close()
  return {
      'statusCode': 200,
      'body': "Success",
      'payload': data
  }