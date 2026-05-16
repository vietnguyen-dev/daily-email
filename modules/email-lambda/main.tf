variable "function_name" {
  description = "Name of the email Lambda function."
  type        = string
}

variable "zip_file_path" {
  description = "Path to the Lambda deployment ZIP."
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

resource "aws_iam_role_policy" "lambda_ses_send" {
  name = "${var.function_name}-ses-send"
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

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = aws_iam_role.lambda_exec.arn
  handler       = "index.handler"
  runtime       = "nodejs22.x"

  filename         = var.zip_file_path
  source_code_hash = filebase64sha256(var.zip_file_path)

  environment {
    variables = {
      FROM_EMAIL = var.from_email
      TO_EMAIL   = var.to_email
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
