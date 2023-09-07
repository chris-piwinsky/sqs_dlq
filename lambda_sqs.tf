data "archive_file" "autofail_archive" {
  type        = "zip"
  source_file = "./files/autofail.py"
  output_path = "./autofail.zip"
}

resource "aws_lambda_function" "autofail_lambda" {
  filename         = "autofail.zip"
  function_name    = "${var.name_prefix}-auto-fail"
  role             = aws_iam_role.autofail_lambda_role.arn
  handler          = "autofail.handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256(data.archive_file.autofail_archive.output_path)
}

resource "aws_iam_role" "autofail_lambda_role" {
  name               = "${var.name_prefix}-autofail-role"
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

resource "aws_iam_policy" "autofail_policy" {
  name        = "${var.name_prefix}-autofail-policy"
  description = "Policy to allow Lambda to send messages to SQS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "sqs:*"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "autofail_lambda_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.autofail_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "autofail_sqs_execution" {
  policy_arn = aws_iam_policy.autofail_policy.arn
  role       = aws_iam_role.autofail_lambda_role.name
}

resource "aws_cloudwatch_log_group" "autofail_lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.autofail_lambda.function_name}"
  retention_in_days = 7
}


output "sqs_lambda_arn" {
  value = aws_lambda_function.autofail_lambda.arn
}
