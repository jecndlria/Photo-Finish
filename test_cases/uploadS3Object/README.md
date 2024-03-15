# uploadS3Object
This function takes in a username, an S3 object key (corresponding to an image), and the points that picture scored according to the rekognition_image_analysis function. This picture is then pushed to RDS into the daily_photos table.
General case:
```json
{
  "username": "novakstorm",
  "object_key": "test.png",
  "points": 50
}
```
Output:
```json
{
    "statusCode": 200,
    "body": 'Success!'
}
```

## Failure case
The two failure cases are a non-existent username and a non-existent S3 object.
## Non-existent username
Input:
```json
{
  "username": "asdfasdfasdfasdfasdfadfasdfasdfasdfasdf",
  "object_key": "test.png",
  "points": 1
}
```

Output:
```json
{
  "statusCode": 500,
  "body": "(1452, 'Cannot add or update a child row: a foreign key constraint fails (`photofinish`.`daily_photos`, CONSTRAINT `link_usernames` FOREIGN KEY (`username`) REFERENCES `user_accounts` (`username`))')"
}
```

## Non-existent object
Input:
```json
{
  "username": "novakstomr",
  "object_key": "asdkfhjsakldfjlaks",
  "points": 1
}
```

Output:
```json
{
  "statusCode": 500,
  "body": "Object does not exist"
}
```