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

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_exec" {
  name               = "${var.lambda_function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_ses_send" {
  name = "${var.lambda_function_name}-ses-send"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "sns_lambda_exec" {
  name               = "${var.sns_lambda_function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "sns_lambda_basic_execution" {
  role       = aws_iam_role.sns_lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "sns_lambda_publish" {
  name = "${var.sns_lambda_function_name}-sns-publish"
  role = aws_iam_role.sns_lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_sns_topic" "sms" {
  name = "vera-daily-sms"
}

resource "aws_lambda_function" "this" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_exec.arn
  handler       = "index.handler"
  runtime       = "nodejs22.x"

  filename         = "${path.module}/email-lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/email-lambda.zip")

  environment {
    variables = {
      FROM_EMAIL = var.from_email
      TO_EMAIL   = var.to_email
    }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_basic_execution]
}

resource "aws_lambda_function" "sns" {
  function_name = var.sns_lambda_function_name
  role          = aws_iam_role.sns_lambda_exec.arn
  handler       = "index.handler"
  runtime       = "nodejs22.x"

  filename         = "${path.module}/sns-lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/sns-lambda.zip")

  environment {
    variables = {
      PHONE_NUMBER = var.phone_number
      SNS_TOPIC_ARN = aws_sns_topic.sms.arn
    }
  }

  depends_on = [aws_iam_role_policy_attachment.sns_lambda_basic_execution]
}

output "lambda_function_name" {
  value = aws_lambda_function.this.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.this.arn
}

output "sns_lambda_function_name" {
  value = aws_lambda_function.sns.function_name
}

output "sns_lambda_function_arn" {
  value = aws_lambda_function.sns.arn
}

output "sns_topic_arn" {
  value = aws_sns_topic.sms.arn
}
