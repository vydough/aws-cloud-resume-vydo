resource "aws_lambda_function" "myfunc" {
    filename = data.archive_file.zip.output_path
    source_code_hash = data.archive_file.zip.output_base64sha256 
    function_name = "myfunc"
    role = aws_iam_role.iam_for_lambda.arn
    handler = "func.lambda_handler"
    runtime = "python3.12"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_resume_project" {
    name = "aws_iam_policy_for_terraform_resume_project_policy"
    path = "/"
    description = "AWS IAM Policy for managing the resume project role"
        policy = jsonencode(
            {
                "Version": "2012-10-17",
                "Statement" : [
                    {
                        "Action" : [
                            "logs:CreateLogGroup",
                            "logs:CreateLogStream",
                            "logs:PutLogEvents"
                        ],
                        "Resource" : "arn:aws:logs:*:*:*",
                        "Effect" : "Allow"
                    },
                    {
                        "Effect" : "Allow",
                        "Action" : [
                            "dynamodb:GetItem",
                            "dynamodb:PutItem",
                            "dynamodb:UpdateItem"
                        ],
                        "Resource": "arn:aws:dynamodb:ap-southeast-2:750910789284:table/visitor-counter-vydo"
                    },
                ]
            }
        )
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
    role = aws_iam_role.iam_for_lambda.name
    policy_arn = aws_iam_policy.iam_policy_for_resume_project.arn
}


data "archive_file" "zip" {
    type = "zip"
    source_file = "${path.module}/func.py"
    output_path = "${path.module}/packedlambda.zip"
}

resource "aws_lambda_function_url" "url1" {
    function_name = aws_lambda_function.myfunc.function_name
    authorization_type = "NONE"

    cors {
        allow_credentials = true 
        allow_origins = ["*"]
        allow_methods = ["*"]
        allow_headers = ["date", "keep-alive"]
        expose_headers = ["keep-alive", "date"]
        max_age = 86400
    }
}