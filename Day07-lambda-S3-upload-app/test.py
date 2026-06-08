 # create a python code to say hello from lambda function and return the message in json format.
import json

def lambda_handler(event, context):
    # TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps('Hello My World!')
    }