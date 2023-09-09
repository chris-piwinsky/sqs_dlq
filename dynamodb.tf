resource "aws_dynamodb_table" "retry_table" {
  name           = "${var.name_prefix}-table"
  billing_mode   = "PAY_PER_REQUEST"  # You can adjust this to provisioned if needed
  hash_key       = "id"
  attribute {
    name = "id"
    type = "S"
  }
}