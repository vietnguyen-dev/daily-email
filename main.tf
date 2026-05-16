terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

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

variable "sns_lambda_function_name" {
  description = "Name of the SNS SMS Lambda function."
  type        = string
  default     = "vera-daily-sms"
}

variable "phone_number" {
  description = "Destination phone number for SNS SMS in E.164 format."
  type        = string
}

variable "from_email" {
  description = "Verified SES sender email address."
  type        = string
}

variable "to_email" {
  description = "Destination email address."
  type        = string
}

provider "aws" {
  region = var.aws_region
}

resource "aws_sns_topic" "sms" {
  name = "vera-daily-sms"
}

module "email_lambda" {
  source = "./modules/email-lambda"

  function_name = var.lambda_function_name
  zip_file_path = "${path.module}/email-lambda.zip"
  from_email    = var.from_email
  to_email      = var.to_email
}

module "sns_lambda" {
  source = "./modules/sns-lambda"

  function_name = var.sns_lambda_function_name
  zip_file_path = "${path.module}/sns-lambda.zip"
  phone_number  = var.phone_number
  sns_topic_arn = aws_sns_topic.sms.arn
}

output "lambda_function_name" {
  value = module.email_lambda.function_name
}

output "lambda_function_arn" {
  value = module.email_lambda.function_arn
}

output "sns_lambda_function_name" {
  value = module.sns_lambda.function_name
}

output "sns_lambda_function_arn" {
  value = module.sns_lambda.function_arn
}

output "sns_topic_arn" {
  value = aws_sns_topic.sms.arn
}
