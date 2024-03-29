# Photo Finish

By Joshua Candaleria, Hallie Pham, Samarth Srinivasa, Angelika Bermudez, and Yuchen Zhu

## Docs for Development

Drive Link: https://drive.google.com/drive/u/3/folders/1qi1kIUQad6aGMQsWT2ZEQTJ-bCvBfybs

Trello Link: https://trello.com/b/5hir3deU/photo-finish

Stuff you need (ask Josh):

1. AWS Application Tag (for creating AWS resources/functions and linking to application)
2. IAM login and password (logging into console)
3. IAM public and secret access key (use AWS Swift APK)
4. AWS_REGION is `us-west-1`

## Using Swift SDK

1. Create environment variables `AWS_REGION`, `AWS_ACCESS_KEY_ID`, and `AWS_SECRET_ACCESS_KEY`
![image](https://github.com/jecndlria/Photo-Finish/assets/73074625/1b1f19d2-e34a-403c-adb7-3b4a2c4197d5)

2. 


## Creating new Lambda function

1. Create the new Lambda function on the AWS console

![image](https://github.com/jecndlria/Photo-Finish/assets/73074625/6316b6df-047d-4e19-bc12-e1d5c0a92d56)

Ensure that the tag is properly added to the function (ask Josh for the value)

![image](https://github.com/jecndlria/Photo-Finish/assets/73074625/43ea91a8-c44f-410d-993b-c3d92ac5558c)

In the Runtime Settings tab, change the handler to `(function_name).lambda_handler`.

2. Add a new Github action job to `./github/workflows/main.yml`

```yml
  update_lambda_test1: # Change this line
    runs-on: ubuntu-latest
    needs: [checkout, configure_dep]
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-west-1
      - name: Create test1 zip file # Change this line
        run: |
          cd src/lambda/test1 # Change this line
          zip -r test1.zip . # Change this line
      - name: Update test1 function # Change this line
        run: |
          aws lambda update-function-code \
          --function-name test1 \ # Change this line
          --zip-file fileb://src/lambda/test1/test1.zip \ # Change this line
          --publish 
```

...substituting `test1` for the actual name of the Lambda function you create.

3. Create the corresponding directory in `src/lambda/` for your new Lambda function. Pushing your commit will update the code on AWS automatically, thanks to the GitHub action.

```
cd src/lambda
mkdir test1
touch test1.py
```

Make sure the lambda function has this name, otherwise it will not run! We will identify lambda functions by file name.
```py
def lambda_handler(event, context):
  return {
    "status": 200,
    "body": "Hello!"
  }
```
