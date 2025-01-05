provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "ap_south_1"
  region = "ap-south-1"
}

# Lambda Function Role
resource "aws_iam_role" "lambda_role" {
  name               = "lambda_execution_roleTBD"
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

resource "aws_iam_policy_attachment" "lambda_execution_policy" {
  name       = "lambda_execution_policy_attachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function for us-east-1
resource "aws_lambda_function" "lambda_us_east_1" {
  provider         = aws.us_east_1
  function_name    = "multi-region-lambda-us-east-1"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  filename         = "./lambda/lambda_function.zip"

  environment {
    variables = {
      REGION = "us-east-1"
    }
  }
}

# Lambda Function for ap-south-1
resource "aws_lambda_function" "lambda_ap_south_1" {
  provider         = aws.ap_south_1
  function_name    = "multi-region-lambda-ap-south-1"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  filename         = "./lambda/lambda_function.zip"

  environment {
    variables = {
      REGION = "ap-south-1"
    }
  }
}

# API Gateway in us-east-1
resource "aws_api_gateway_rest_api" "api_us_east_1" {
  provider = aws.us_east_1
  name     = "MultiRegionAPI-East"
}

resource "aws_api_gateway_resource" "resource_us_east_1" {
  provider   = aws.us_east_1
  rest_api_id = aws_api_gateway_rest_api.api_us_east_1.id
  parent_id   = aws_api_gateway_rest_api.api_us_east_1.root_resource_id
  path_part   = "lambda"
}

resource "aws_api_gateway_method" "method_us_east_1" {
  provider   = aws.us_east_1
  rest_api_id = aws_api_gateway_rest_api.api_us_east_1.id
  resource_id = aws_api_gateway_resource.resource_us_east_1.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration_us_east_1" {
  provider   = aws.us_east_1
  rest_api_id = aws_api_gateway_rest_api.api_us_east_1.id
  resource_id = aws_api_gateway_resource.resource_us_east_1.id
  http_method = aws_api_gateway_method.method_us_east_1.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.lambda_us_east_1.invoke_arn
}

resource "aws_lambda_permission" "permission_us_east_1" {
  provider       = aws.us_east_1
  statement_id   = "AllowAPIGatewayInvoke"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.lambda_us_east_1.function_name
  principal      = "apigateway.amazonaws.com"
  source_arn     = "${aws_api_gateway_rest_api.api_us_east_1.execution_arn}/*/*"
}

# API Gateway in ap-south-1
resource "aws_api_gateway_rest_api" "api_ap_south_1" {
  provider = aws.ap_south_1
  name     = "MultiRegionAPI-South"
}

resource "aws_api_gateway_resource" "resource_ap_south_1" {
  provider   = aws.ap_south_1
  rest_api_id = aws_api_gateway_rest_api.api_ap_south_1.id
  parent_id   = aws_api_gateway_rest_api.api_ap_south_1.root_resource_id
  path_part   = "lambda"
}

resource "aws_api_gateway_method" "method_ap_south_1" {
  provider   = aws.ap_south_1
  rest_api_id = aws_api_gateway_rest_api.api_ap_south_1.id
  resource_id = aws_api_gateway_resource.resource_ap_south_1.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration_ap_south_1" {
  provider   = aws.ap_south_1
  rest_api_id = aws_api_gateway_rest_api.api_ap_south_1.id
  resource_id = aws_api_gateway_resource.resource_ap_south_1.id
  http_method = aws_api_gateway_method.method_ap_south_1.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.lambda_ap_south_1.invoke_arn
}

resource "aws_lambda_permission" "permission_ap_south_1" {
  provider       = aws.ap_south_1
  statement_id   = "AllowAPIGatewayInvoke"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.lambda_ap_south_1.function_name
  principal      = "apigateway.amazonaws.com"
  source_arn     = "${aws_api_gateway_rest_api.api_ap_south_1.execution_arn}/*/*"
}