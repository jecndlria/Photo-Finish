# Photo Finish

Drive Link: https://drive.google.com/drive/u/3/folders/1qi1kIUQad6aGMQsWT2ZEQTJ-bCvBfybs

Trello Link: https://trello.com/b/5hir3deU/photo-finish

## Creating new Lambda function

1. Create the new Lambda function on the AWS console

![image](https://github.com/jecndlria/Photo-Finish/assets/73074625/6316b6df-047d-4e19-bc12-e1d5c0a92d56)

Ensure that the tag is properly added to the function (ask Josh for the value)

2. Add a new Github action job to `./github/workflows/main.yml`

```yml
  update_lambda_test1: # Change this line
    runs-on: ubuntu-latest
    needs: [checkout, configure_dep]
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
      - name: Update only on changes in src/lambda/test1 # Change this line
        id: check-changes-test1 # Change this line
        run: |
          if [ -n "$(git diff --name-only ${{ github.sha }}..$GITHUB_SHA | grep '^src/lambda/test1')" ]; then # Change this line
            echo "Changes detected in src/lambda/test1. Proceeding with the workflow." # Change this line
          else
            echo "No changes in src/lambda/test1. Skipping the workflow." # Change this line
            exit 78
          fi
        continue-on-error: true
      - name: Configure AWS Credentials
        if: success() && steps.check-changes-test1.outcome == 'success' # Change this line
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-west-1
      - name: Create test1 zip file # Change this line
        if: success() && steps.check-changes-test1.outcome == 'success' # Change this line
        run: |
          cd src/lambda/test1 # Change this line
          zip -r test1.zip . # Change this line
      - name: Update test1 function # Change this line
        if: success() && steps.check-changes-test1.outcome == 'success' # Change this line
        run: |
          aws lambda update-function-code \
          --function-name test1 \ # Change this line
          --zip-file fileb://src/lambda/test1/test1.zip # Change this line
```

...substituting `test1` for the actual name of the Lambda function you create.

3. Create the corresponding directory in `src/lambda/` for your new Lambda function

```
cd src/lambda
mkdir test1
touch test1.py
```
