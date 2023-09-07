# import json
# import boto3

# dynamodb = boto3.client('dynamodb')

# def lambda_handler(event, context):

#     for record in event['Records']:
#         message_body = json.loads(record['body'])

#         # Extract data from the message, e.g., message_body['data']

#         # Insert data into DynamoDB
#         response = dynamodb.put_item(
#             TableName='YourDynamoDBTableName',
#             Item={
#                 'PrimaryKey': {
#                     'S': message_body['key']
#                 },
#                 'Attribute1': {
#                     'S': message_body['value1']
#                 },
#                 'Attribute2': {
#                     'N': str(message_body['value2'])
#                 }
#             }
#         )

import json
import boto3
import os
import datetime

sqs = boto3.client('sqs')


def handler(event, context):
    print("Received event:")
    print("event arrived at: ", datetime.datetime.now().isoformat())
    print(event)
    for record in event['Records']:
        try:
            message_body = json.dumps(record['body'])
            print('Message Body: ', message_body)
            # Check the retry count or set it to 0 if it doesn't exist
            retry_count = message_body.get('retry_count', 0)
            print("RETRY COUNT: ", retry_count)
            if retry_count >= 3:
                current_timestamp = datetime.datetime.now().isoformat()
                print(f"Received event at {current_timestamp}: {json.dumps(event)}")
                 # Append the timestamp to the error message
                error_message = f"{str(e)} (Occurred at {current_timestamp})"
                raise Exception(error_message)
            else:
                # Increment the retry count
                retry_count += 1
                print('Message Retry count set to: ', retry_count)
                # Update the message with the new retry count
                message_body['retry_count'] = retry_count

                # Reinsert the message into the main queue
                response = sqs.send_message(
                    QueueUrl=os.environ['MAIN_QUEUE'],
                    MessageBody=json.dumps(message_body)
                )
                print("Response:", response)
                return {
                    "statusCode": 200,
                    "body": json.dumps(response)
                }

        except json.JSONDecodeError as e:
            print("Error parsing JSON:", str(e))
            # Handle the invalid JSON gracefully, e.g., log the error and continue
