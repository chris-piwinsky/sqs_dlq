resource "aws_sqs_queue" "dlq" {
  name                       = "${var.name_prefix}-dlq"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 1209600 # Adjust this based on your needs (default is 14 days)
  visibility_timeout_seconds = 30
}

resource "aws_lambda_event_source_mapping" "dlq_to_lambda" {
  event_source_arn = aws_sqs_queue.dlq.arn
  function_name    = aws_lambda_function.dynamo_insert.function_name
}

resource "aws_sqs_queue" "main_queue" {
  name                       = "${var.name_prefix}-main-queue"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 1209600 # Adjust this based on your needs (default is 14 days)
  visibility_timeout_seconds = 30

  # Define the redrive policy
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn,
    maxReceiveCount     = 2 # Number of retry attempts
  })
}

resource "aws_lambda_event_source_mapping" "main_queue_to_lambda" {
  event_source_arn = aws_sqs_queue.main_queue.arn
  function_name    = aws_lambda_function.autofail_lambda.function_name
}
