# new_friend
This function takes 2 parameters: the user who initiates the friend removal (username), and the target (friend).
In the general use case (both users exist):
Input:
```json
{
    "username": "joshtet",
    "friend": "formula1"
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
The only failure case would be if one or the other (or both) users didn't exist. We don't want to modify the database in that case.
Input:
```json
{
    "username": "joshtest",
    "friend": "formula2"
}
```
Output:
```json
{
    "statusCode": 500,
    "body": 'Error'
}
```