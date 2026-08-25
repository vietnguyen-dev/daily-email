terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "email_lambda" {
  source = "./modules/email-lambda"

  function_name = var.lambda_function_name
  zip_file_path = "${path.module}/email-lambda.zip"
  from_email    = var.from_email
  to_email      = var.to_email
}

data "aws_iam_policy_document" "scheduler_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "daily_email_scheduler" {
  name               = "${var.lambda_function_name}-scheduler-role"
  assume_role_policy = data.aws_iam_policy_document.scheduler_assume_role.json
}

resource "aws_iam_role_policy" "daily_email_scheduler_invoke" {
  name = "${var.lambda_function_name}-scheduler-invoke"
  role = aws_iam_role.daily_email_scheduler.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "lambda:InvokeFunction"
        Resource = module.email_lambda.function_arn
      }
    ]
  })
}

resource "aws_scheduler_schedule" "daily_email" {
  name                         = "${var.lambda_function_name}-daily"
  description                  = "Invoke ${var.lambda_function_name} every day at 5:30 PM Pacific time."
  schedule_expression          = "cron(30 17 * * ? *)"
  schedule_expression_timezone = "America/Los_Angeles"

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = module.email_lambda.function_arn
    role_arn = aws_iam_role.daily_email_scheduler.arn
  }
}

output "lambda_function_name" {
  value = module.email_lambda.function_name
}

output "lambda_function_arn" {
  value = module.email_lambda.function_arn
}

output "daily_email_schedule_name" {
  value = aws_scheduler_schedule.daily_email.name
}
