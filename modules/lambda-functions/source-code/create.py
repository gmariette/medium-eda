import json
import logging
import boto3
import json

def lambda_handler(event, context):
    logger = logging.getLogger('CREATE')
    logger.setLevel(logging.INFO)
    message = json.loads(event['Records'][0].get('body'))
    logger.info(message)
