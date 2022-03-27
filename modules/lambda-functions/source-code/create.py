import json
import logging
import boto3

def lambda_handler(event, context):
    body = json.loads(event['Records'][0].get('body'))
    
