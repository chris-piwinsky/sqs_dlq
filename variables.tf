variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "REGION" {}

variable "name_prefix" {
  description = "Queue name will name both the main queue and dlq with this prefix"
  type        = string
  default     = "retry-poc"
}

variable "number_of_retries" {
  description = "Number of retries you would want before sending record to be stored in DynamoDB table"
  type = number
  default = 3
}
