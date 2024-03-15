# get_leaderboard
The get_leaderboard function takes in one parameter: the current user's username. It returns the total scores of each of their friends.

For a proper user that exists:
Input:
```json
{
  "username": "joshtet"
}
```
Output:
```json
{
  "statusCode": 200,
  "body": "Success",
  "payload": {
    "formula1": 0,
    "aberm028": 0,
    "novakstorm": 0,
    "Samarth": 0
  }
}
```

## Failure case
The only failure case would be if a user has no friends. In that case, we simply want to return an empty payload since we don't want that to be a failure. This same thing would happen with a user who doesn't exist.
```json
{
  "username": ""
}
```
Output:
```json
{
  "statusCode": 200,
  "body": "Success",
  "payload": {}
}
```