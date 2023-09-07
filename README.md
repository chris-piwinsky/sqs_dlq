# AWS Lambda Function with Dead Letter Queue (DLQ) Example

This project demonstrates how to set up an AWS Lambda function to process events, configure a Dead Letter Queue (DLQ) for error handling, and use Terraform for infrastructure as code (IaC).

## Table of Contents

- [Prerequisites](#prerequisites)
- [Lambda Function](#lambda-function)
  - [Lambda Code](#lambda-code)
  - [Lambda Configuration](#lambda-configuration)
  - [Lambda IAM Role](#lambda-iam-role)
- [Dead Letter Queue (DLQ)](#dead-letter-queue-dlq)
  - [SQS Queue Configuration](#sqs-queue-configuration)
  - [Lambda DLQ Configuration](#lambda-dlq-configuration)
- [Terraform Configuration](#terraform-configuration)
- [Deployment](#deployment)
- [Testing](#testing)
- [Monitoring](#monitoring)
- [Troubleshooting](#troubleshooting)
- [Cleaning Up](#cleaning-up)

## Prerequisites

Before you begin, make sure you have the following:

- An AWS account with appropriate permissions.
- AWS CLI installed and configured with the necessary access keys and region.
- Terraform installed on your local machine.

## Lambda Function

### Lambda Code

1. Create a Python Lambda function in a file named `helloworld.py`. This function will process incoming events.

```python
import json

def handler(event, context):
    # Your Lambda function logic here
    try:
        # Process the event payload
        result = "Event processed successfully!"
        return {
            "statusCode": 200,
            "body": json.dumps(result)
        }
    except Exception as e:
        # Log errors and let AWS Lambda handle retries and error handling
        raise e
```

### Lambda Configuration

2. Configure the Lambda function using AWS Lambda Console, AWS CLI, or Terraform, specifying the `hello.handler` as the handler.

### Lambda IAM Role

3. Ensure the Lambda function's IAM role has the necessary permissions to execute the function and access other AWS services as required.

## Dead Letter Queue (DLQ)

### SQS Queue Configuration

4. Create an SQS (Simple Queue Service) queue named `MyDLQ` (or your preferred name) using the AWS Management Console, AWS CLI, or Terraform. Configure the SQS queue with your desired settings.

### Lambda DLQ Configuration

5. Configure the Lambda function to use the DLQ:

   - In the AWS Lambda Console, go to the Lambda function.
   - Under "Function overview," scroll down to the "Dead letter queue" section.
   - Choose "Edit" and select the `MyDLQ` queue created earlier.

## Terraform Configuration

6. Define the infrastructure using Terraform. Create Terraform configuration files to define AWS resources, including the Lambda function, IAM role, and the SQS queue.

7. In the Terraform configuration, ensure that the IAM role attached to the Lambda function has the appropriate permissions to interact with SQS.

## Deployment

8. Use Terraform to apply the configuration, creating the Lambda function, IAM role, and SQS queue:

```bash
terraform init
terraform apply
```

## Testing

9. Trigger the Lambda function to process events, and verify that it works as expected.

## Monitoring

10. Monitor the AWS CloudWatch Logs for both the Lambda function and the SQS queue. AWS CloudWatch Metrics can provide insights into the performance and behavior of your Lambda function.

## Troubleshooting

11. If issues arise, refer to the CloudWatch Logs and Metrics for error messages and debugging information.

## Cleaning Up

12. When you're finished with the project, remove the resources using Terraform:

```bash
terraform destroy
```

This README provides a high-level overview of setting up an AWS Lambda function with a Dead Letter Queue (DLQ) and using Terraform for infrastructure management. Adjust the configurations and steps to match your specific requirements and naming conventions.

Feel free to expand on this README with additional details and specific configurations related to your project.

```CLI
aws events put-events --entries '[{"Source":"custom.application","DetailType":"eventName","Detail":"{\"eventName\":\"triggerLambda\"}"}]'
```
