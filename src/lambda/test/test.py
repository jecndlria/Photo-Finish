def lambda_handler(event, context):
    print(event)
    return {
        "status": 200,
        "body": "Hello!",
    }
