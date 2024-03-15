# get_feed
The get_feed function takes in one parameter: the current user's username. It returns the photo URLs of each of their friend's pictures for the day, and their scores.

For a proper user that exists:
Input:
```json
{
  "username": "joshtet"
}
```
Output:
```json

  "statusCode": 200,
  "body": "Success",
  "payload": {
    "formula1": "https://photo-finish-bucket.s3.amazonaws.com/formula120240314191249.png",
    "aberm028": "https://photo-finish-bucket.s3.amazonaws.com/test.png",
    "novakstorm": "https://photo-finish-bucket.s3.amazonaws.com/test.png"
  },
  "scores": {
    "formula1": 0,
    "aberm028": 0,
    "novakstorm": 1
  }
```
## Failure cases
This function is read only, so we don't need to worry about erroneous writes.
## Friends don't have pictures/user doesn't exist
This is output if the query returns has a length of 0, either because of the user not existing or none of their friends took a picture yet.
Input:
```json
{
  "username": "a"
}
```

Output:
```json
{
  "statusCode": 500,
  "body": "{\"error\": \"No photos found for friends of the user a.\"}"
}
```
