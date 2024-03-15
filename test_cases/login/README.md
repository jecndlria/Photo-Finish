# login
This function takes 2 parameters: `username` and `password`. We check to see if the user has input the valid password for their username. Note that we don't do any hashing as per the limitations stated in our report.

General case:
Input:
```json
{
  "username": "joshtet",
  "password": "Asdf123!"
}
```
Output:
```json
{
  "statusCode": 200,
  "body": "Success!"
}
```

## Failure cases:

## Invalid password
Input:
```json
{
  "username": "joshtet",
  "password": "Asdf123"
}
```

Output:
```json
{
    "statusCode": 300,
    "body": 'Incorrect password!'
}
```

## Invalid user (DNE)
Input:
```json
{
  "username": "joshtest",
  "password": "Asdf123"
}
```

Output:
```json
{
    "statusCode": 400,
    "body": 'Unknown username!'
}
```