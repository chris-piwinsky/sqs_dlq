import json
import boto3
import os
import datetime

sqs = boto3.client('sqs')


def handler(event, context):
    print("event arrived at: ", datetime.datetime.now().isoformat())
    print(event)
    for record in event['Records']:
        try:
            message_body = json.dumps(record['body'])
            retry_count = int(record['messageAttributes'].get('retry_count', {'stringValue': '0'})['stringValue'])
            print('Message Body: ', message_body)
            print('Retry Count: ' , retry_count )
            # Check the retry count or set it to 0 if it doesn't exist
            if retry_count >= 3:
                current_timestamp = datetime.datetime.now().isoformat()
                print(f"Received event at {current_timestamp}: {json.dumps(event)}")
                 # Append the timestamp to the error message
                error_message = "exceeded retry count"
                raise Exception(error_message)
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
