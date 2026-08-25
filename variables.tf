variable "aws_region" {
  description = "AWS region for the Lambda deployment."
  type        = string
  default     = "us-west-2"
}

variable "lambda_function_name" {
  description = "Name of the email Lambda function."
  type        = string
  default     = "vera-daily-email"
}

variable "from_email" {
  description = "Verified SES sender email address."
  type        = string
}

variable "to_email" {
  description = "Destination email address."
  type        = string
}
