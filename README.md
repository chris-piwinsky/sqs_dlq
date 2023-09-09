# Table of Contents
- [SQS Retry Handler with DLQ and DynamoDB](#sqs-retry-handler-with-dlq-and-dynamodb)
  - [Overview](#overview)
  - [Exponential Backoff for Retries](#exponential-backoff-for-retries)
    - [How Exponential Backoff Works](#how-exponential-backoff-works)
    - [Benefits of Exponential Backoff](#benefits-of-exponential-backoff)
    - [Configuration](#configuration)
  - [References](#references)

# SQS Retry Handler with DLQ and DynamoDB

This project demonstrates a retry handler for AWS Lambda using Amazon SQS (Simple Queue Service), Dead Letter Queue (DLQ), and DynamoDB. The Lambda function processes messages from an SQS DLQ, tracks the retry count, and takes actions based on the retry count.

## Overview

The project is composed of the following components:

1. **AWS Lambda Function**: The Lambda function is triggered by the DLQ queue. It receives messages, tracks the retry count, and based on that value either:
    - Send to the main queue using [exponential backoff](./documentation/EXPONENTIAL.MD) before sending back to the main queue.

2. **SQS Queue**: The main SQS queue where messages are initially sent.

3. **Dead Letter Queue (DLQ)**: An SQS queue designated as the DLQ. When messages fail after reaching the maximum retry count, they are sent to the DLQ.

4. **DynamoDB Table**: A DynamoDB table is used to store records of messages that have exceeded the maximum retry count.


## Prerequisites
Before you begin, make sure you have the following prerequisites:

* [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) installed on your local machine.
* An AWS account.
* AWS access key and secret key with sufficient permissions to create resources.

## Infrastructure Setup

* Clone the repository to your local machine.
* Navigate to the project directory.
* Create a `terraform.tfvars` adding your AWS_ACCESS_KEY, AWS_SECRET_KEY, and REGION.
* Run `terraform init` to download the necessary provider plugins.
* Run `terraform plan` to preview the changes that Terraform will make to your infrastructure.
* Run `terraform apply` to create the infrastructure on AWS.
* When you are finished using the infrastructure, run `terraform destroy` to delete all the resources that Terraform created.

### References

- [Using Amazon SQS dead-letter queues to replay messages](https://aws.amazon.com/blogs/compute/using-amazon-sqs-dead-letter-queues-to-replay-messages/)
