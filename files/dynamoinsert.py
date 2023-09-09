import json
import boto3
import os
import datetime

dynamodb = boto3.client('dynamodb')
sqs = boto3.client('sqs')


def handler(event, context):
    print("event arrived at: ", datetime.datetime.now().isoformat())
    print(event)
    for record in event['Records']:
        try:
            message_body = record['body']
            retry_count = int(record['messageAttributes'].get('retry_count', {'stringValue': '0'})['stringValue'])
            print('Message Body: ', message_body)
            print('Retry Count: ' , retry_count )
            # Check the retry count or set it to 0 if it doesn't exist
            if retry_count >= int(os.environ['RETRY_COUNT']):
                current_timestamp = datetime.datetime.now().isoformat()
                print(f"Received event at {current_timestamp}: {json.dumps(event)}")
                 # Append the timestamp to the error message
                
                response = dynamodb.put_item(
                    TableName=os.environ['DYNAMODB_TABLE'],
                    Item={
                        'id': {'S': str(datetime.datetime.now())},  # Unique ID
                        'message_body': {'S': message_body},
                        'timestamp': {'S': current_timestamp},
                        'retry_count': {'N': str(retry_count)}
                    })
                return {
                    "statusCode": 200,
                    "body": json.dumps(response)
                }
            else:
                # Increment the retry count
                retry_count += 1
                print('Message Retry count set to: ', retry_count)
                # Update the message with the new retry count
                message_attributes = {
                    'retry_count': {
                        'DataType': 'String',
                        'StringValue': str(retry_count)
                    }
                }
                # Reinsert the message into the main queue
                response = sqs.send_message(
                    QueueUrl=os.environ['MAIN_QUEUE'],
                    MessageBody=message_body,
                    MessageAttributes=message_attributes
                )
                print("Response:", response)
                return {
                    "statusCode": 200,
                    "body": json.dumps(response)
                }

        except json.JSONDecodeError as e:
            print("Error parsing JSON:", str(e))
            # Handle the invalid JSON gracefully, e.g., log the error and continue
