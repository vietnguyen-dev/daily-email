variable "function_name" {
  description = "Name of the SNS Lambda function."
  type        = string
}

variable "zip_file_path" {
  description = "Path to the Lambda deployment ZIP."
  type        = string
}

variable "phone_number" {
  description = "Destination phone number for SNS SMS in E.164 format."
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic used by the Lambda."
  type        = string
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
  name               = "${var.function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_publish" {
  name = "${var.function_name}-sns-publish"
  role = aws_iam_role.lambda_exec.id

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

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = aws_iam_role.lambda_exec.arn
  handler       = "index.handler"
  runtime       = "nodejs22.x"

  filename         = var.zip_file_path
  source_code_hash = filebase64sha256(var.zip_file_path)

  environment {
    variables = {
      PHONE_NUMBER  = var.phone_number
      SNS_TOPIC_ARN = var.sns_topic_arn
    }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_basic_execution]
}

output "function_name" {
  value = aws_lambda_function.this.function_name
}

output "function_arn" {
  value = aws_lambda_function.this.arn
}
