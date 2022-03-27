
import logging
import os
import boto3
import json

def lambda_handler(event, context):
    """
    Send a message to an Amazon SQS queue.

    :param queue: The queue that receives the message.
    :param message_body: The body text of the message.
    :param message_attributes: Custom attributes of the message. These are key-value
                               pairs that can be whatever you want.
    :return: The response from SQS that contains the assigned message ID.
    """
    logger = logging.getLogger('SUBMIT-SPOT-TO-SQS')
    logger.setLevel(logging.INFO)
    client = boto3.client('sqs')   
    event_body = json.loads(event.get('body'))
    try:
        queue_url = os.environ['QUEUE_URL']
    except:
        return {
            "isBase64Encoded": False,
            "statusCode": 502,
            "body": json.dumps({'error': 'Missing argument'})
        }

    for i, submission in enumerate(event_body, 1):
        try:
            logger.info('Sending message %s/%s', i, len(event_body))
            response = client.send_message(
                QueueUrl=queue_url,
                MessageBody=json.dumps(event_body.get(submission))
            )
            logger.info('Meesage %s/%s sent !', i, len(event_body))
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