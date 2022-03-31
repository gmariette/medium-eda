
import logging
import os
import boto3
import json

def lambda_handler(event, context):
    """
    Send a message to an Amazon SQS queue.
    """
    logger = logging.getLogger('SUBMIT-SPOT-TO-SQS')
    logger.setLevel(logging.INFO)
    client = boto3.client('sqs')   
    try:
        queue_url = os.environ['QUEUE_URL']
    except:
        return {
            "isBase64Encoded": False,
            "statusCode": 502,
            "body": json.dumps({'error': 'Missing argument'})
        }

    for i, row in enumerate(event, 1):
        try:
            logger.info('Sending message %s/%s', i, len(event))
            response = client.send_message(
                QueueUrl=queue_url,
                MessageBody=json.dumps(event.get(row))
            )
            logger.info('Meesage %s/%s sent !', i, len(event))
        except Exception as e:
            logger.exception("Send message failed: %s", e)
            return {
                "isBase64Encoded": False,
                "statusCode": 502,
                "body": json.dumps({'error': 'ExceptionUnableToSendToSQS'})
            }
    return {
        "isBase64Encoded": False,
        "statusCode": 200,
        "body": json.dumps({
            "Status": "Sent",
            'Message': f'Successfully sent {i} {"message" if i == 1 else "messages"}, we will analyse {"it" if i == 1 else "them"} shortly'})
    }