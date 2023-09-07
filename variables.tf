variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "REGION" {}

variable "name_prefix" {
  description = "Queue name will name both the main queue and dlq with this prefix"
  type        = string
  default     = "retry-poc"
}
