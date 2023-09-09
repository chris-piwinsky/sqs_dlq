# SQS Retry Handler with DLQ and DynamoDB

This project demonstrates a retry handler for AWS Lambda using Amazon SQS (Simple Queue Service), Dead Letter Queue (DLQ), and DynamoDB. The Lambda function processes messages from an SQS DLQ, tracks the retry count, and takes actions based on the retry count.

## Overview

The project is composed of the following components:

1. **AWS Lambda Function**: The Lambda function is triggered by an The DLQ queue. It receives messages, tracks the retry count, and performs actions based on the retry count.

2. **SQS Queue**: The main SQS queue where messages are initially sent.

3. **Dead Letter Queue (DLQ)**: An SQS queue designated as the DLQ. When messages fail after reaching the maximum retry count, they are sent to the DLQ.

4. **DynamoDB Table**: A DynamoDB table is used to store records of messages that have exceeded the maximum retry count.


