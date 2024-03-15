The generate_prompt function doesn't take any input. 
This function is triggered by an AWS CloudWatch event every 24 hours (midnight PST), which generates a prompt from all possbile Amazon Rekognition labels and pushes the result into the daily_prompts table in our database.
Any input to this function is discarded, and is expected to output this:

```json
{
    'statusCode': 200
    'body': 'Success!'
}
```

...when a new prompt is successfully generated.

The two failure cases would be if the network connection to the SQL server times out, in which case the output is `null`. 
The other failure case is a corrupt CSV file, in which case the output is:
```
Error reading CSV file
```