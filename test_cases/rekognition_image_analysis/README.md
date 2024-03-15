# rekognition_image_analysis
This function takes 2 inputs: `Username` and `Name`, where Name is the key for an image in S3.
It returns the score of an image based on the daily prompt.

General case:
The user inputs a picture that exists and contains the prompt:
Input:
```json
{
  "Username": "formula1",
  "Name": "maltese-photo.jpg"
}
```
Output:
```json
{
    "statusCode": 200,
    "body": 'Points updated successfully!',
    "points": points_for_photo // ranges from 0-100 based on picture quality
}
```

## Failure case
In all other cases (no existing user OR existing picture), we want to ensure that the database is not updated.
Input:
```json
{
  "Username": "formula1",
  "Name": "test.jpg"
}
```
Output:
```json
{
  "statusCode": 500,
  "body": "\"An unexpected error occurred!\"",
  "points": 0
}
```