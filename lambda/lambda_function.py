import json
import os

def lambda_handler(event, context):
    # Get the region from environment variables
    aws_region = os.environ['AWS_REGION']
    return {
        'statusCode': 200,
        'body': json.dumps(f"Hello from {aws_region}.")
    }
