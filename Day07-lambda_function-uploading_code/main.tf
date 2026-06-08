# Creation of IAM role and policy for creation of Lambda function
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the AWSLambdaBasicExecutionRole policy to the role
resource "aws_iam_role_policy_attachment" "lambda_execution_role_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Calling the role for creation of Lambda function
resource "aws_lambda_function" "lambdacreation"{               
  function_name = "MyLambdaFunction"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "test.handler"
  runtime       = "python3.11"
  timeout       = 900   
  memory_size   = 256

  # Assuming you have a deployment package ready
  filename      = "test.zip"
}
