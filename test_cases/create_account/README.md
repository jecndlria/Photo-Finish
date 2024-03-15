# create_account
The create_account function expects 4 parameters from a JSON object: `username`, `name`, `password`, and `email`, where this input is used to create a new account and push the details into our AWS RDS database.

Requirements: username must be 5+ characters and unique, email must match the actual email format, and password must contain at least 1 special character, 1 capital letter and 1 number.

If all requirements are met, such as in this input (assume the input parameters don't exist in the database already):

```json
{
  "username": "novakstorm",
  "email": "samarth@gmail.com",
  "password": "Value12312313!",
  "name": "samarthsrinivasa"
}
```

then the output will be the following:

```json
{
        'statusCode': 200,
        'body': 'Success'
}
```

## Failure cases
In faillure cases, we catch exceptions and output the following errors. We ensure the database is not modified in this way.

## Invalid email:
Input:

```json
{
  "username": "novakstorm",
  "email": "asdf",
  "password": "Value12312313!",
  "name": "samarthsrinivasa"
}
```

Output: 

```json
{
  "statusCode": 500,
  "body": "{\"error\": \"An error occurred (InvalidParameterException) when calling the AdminCreateUser operation: Invalid email address format.\"}"
}
```
## Invalid password:
Inputs:

```json
{
  "username": "novakstorm",
  "email": "asdf",
  "password": "Value12312313!",
  "name": "samarthsrinivasa"
}
```
```json
{
  "username": "novakstorm",
  "email": "asdf@gmail.com",
  "password": "asdfasilguhasulf!",
  "name": "samarthsrinivasa"
}
```
```json
{
  "username": "novakstorm",
  "email": "asdf@gmail.com",
  "password": "Asdfasilguhasulf!",
  "name": "samarthsrinivasa"
}
```

Outputs: 

```json
{
  "statusCode": 500,
  "body": "{\"error\": \"An error occurred (InvalidPasswordException) when calling the AdminCreateUser operation: Password did not conform with password policy: Password not long enough\"}"
}
```

```json
{
  "statusCode": 500,
  "body": "{\"error\": \"An error occurred (InvalidPasswordException) when calling the AdminCreateUser operation: Password did not conform with password policy: Password must have uppercase characters\"}"
}
```

```json
{
  "statusCode": 500,
  "body": "{\"error\": \"An error occurred (InvalidPasswordException) when calling the AdminCreateUser operation: Password did not conform with password policy: Password must have numeric characters\"}"
}
```

## Already exists
Input:

Note: same as above!
```json
{
  "username": "novakstorm",
  "email": "samarth@gmail.com",
  "password": "Value12312313!",
  "name": "samarthsrinivasa"
}
```

Output:

```json
{
  "statusCode": 500,
  "body": "{\"error\": \"An error occurred (UsernameExistsException) when calling the AdminCreateUser operation: User account already exists\"}"
}
```

## Invalid input
Input:
Username is omitted (output is same for all other keys)
```json
{
  "email": "asdf@gmail.com",
  "password": "Asdfasilguhasulf!123",
  "name": "samarthsrinivasa"
}
```

Output:
```json
{
  "errorMessage": "'username'",
  "errorType": "KeyError"
}
```