def test(event, context):
    print(event)
    return {
        "status": 200,
        "body": "Hello!",
    }
