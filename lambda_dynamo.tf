data "archive_file" "dynamo_insert" {
  type        = "zip"
  source_file = "./files/dynamoinsert.py"
  output_path = "./dynamoinsert.zip"
}

resource "aws_lambda_function" "dynamo_insert" {
  filename         = "dynamoinsert.zip"
  function_name    = "${var.name_prefix}-dynamoinsert"
  role             = aws_iam_role.dynamo_insert_role.arn
  handler          = "dynamoinsert.handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256(data.archive_file.dynamo_insert.output_path)

  environment {
    variables = {
      MAIN_QUEUE     = aws_sqs_queue.main_queue.id
      DYNAMODB_TABLE = aws_dynamodb_table.retry_table.id
      RETRY_COUNT    = var.number_of_retries
    }
  }
}

resource "aws_iam_role" "dynamo_insert_role" {
  name               = "${var.name_prefix}-lambda-dynamo-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "dynamo_insert_policy" {
  name        = "${var.name_prefix}-lambda-dynamo-policy"
  description = "Policy to allow Lambda to send messages to SQS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "dynamodb:*",
          "sqs:*"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dynamo_insert_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.dynamo_insert_role.name
}

resource "aws_iam_role_policy_attachment" "sqs_execution" {
  policy_arn = aws_iam_policy.dynamo_insert_policy.arn
  role       = aws_iam_role.dynamo_insert_role.name
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.dynamo_insert.function_name}" # Adjust the log group name
  retention_in_days = 7                                                                # Adjust the retention period in days as needed
}


output "dynamo_lambda_arn" {
  value = aws_lambda_function.dynamo_insert.arn
}
