# Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = "ASIAW42QMM5JZR7CXIIB"
  secret_key = "oX0IsBb7wjVhki90FJgFwzR9U1N6C5sS4Ww1a6gg"
  token="FwoGZXIvYXdzEP///////////wEaDFD1O+dyT1ZY4dGZgCLVAf4sjH4zfOysdW++EzvI3Lx9iCe9QTMWSgNPPR4hKpiqRv6fIWn845C/cq++GLqLi2H7DyJkWcQkK3HGeO8YWdvaAVzPliF4M8upy1VQvXxFNKi5FX75Jz54WqDp3bEnEKrAdLD2R5FhBQEoXg2qeWvTCE5D8deGCrYZBvhPhH/DaZuSZminM59W2cDkCgxsmhLHWg8rYAkcPuhjAzmR5IJAk9Stv8TPjkb8SluDC8cU0dJmX1Ocl/SW1i0VT2sh+XiCSKv1FJBXQc0Lts3hO303ZqF6uSiZq7unBjIt7gXQsh7f0yo4FVDvGlIkKttTBqNlDKUcXh7nQ9t9y4k4re2NaZreC9shrjzk"
  region = var.aws_region
}

# Init Lambda
resource "aws_iam_role" "lambda_role" {
  name   = "terraform_aws_lambda_role"
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

# IAM policy for logging from a lambda
resource "aws_iam_policy" "iam_policy_for_lambda" {
  path         = "/"
  name         = "aws_iam_policy_for_terraform_aws_lambda_role"
  description  = "AWS IAM Policy for managing aws lambda role"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*",
        "Effect": "Allow"
      }
    ]
  }
  EOF
}

# Policy Attachment on the role.
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role        = aws_iam_role.lambda_role.name
  policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}

# Generates an archive from content, a file, or a directory of files.
data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_file = "greet_lambda.py"
  output_path = var.lambda_output_path
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 7
}

# Create a lambda function
resource "aws_lambda_function" "terraform_lambda_func" {
  function_name     = var.lambda_name
  filename          = data.archive_file.zip_the_python_code.output_path
  source_code_hash  = data.archive_file.zip_the_python_code.output_base64sha256
  role                           = aws_iam_role.lambda_role.arn
  handler                        = "greet_lambda.lambda_handler"
  runtime                        = "python3.8"

  environment{
      variables = {
          greeting = "Hello DongTP1!"
      }
  }

  depends_on = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role,aws_iam_policy.iam_policy_for_lambda,aws_cloudwatch_log_group.lambda_log_group]
}
