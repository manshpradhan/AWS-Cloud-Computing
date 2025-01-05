Multi-Region Deployment of AWS API Gateway Using Route53 Latency Based Routing 🚀

Overview
This repository demonstrates how to set up a multi-region deployment for an AWS API Gateway using Route53 Latency Based Routing to achieve high availability and low latency. It uses Terraform for infrastructure-as-code and AWS Lambda to handle requests in two AWS regions.

Architecture
The architecture includes:

1. Regions:
- us-east-1 (North America)
- ap-south-1 (Asia-Pacific)

2. API Gateway: Acts as the front door for API requests.
3. Route53: Directs traffic to the region with the lowest latency.
4. AWS Lambda: Processes API requests in both regions.

Repository Structure

├── lambda/
│   ├── lambda_function.py       # Your Lambda function code
│   └── lambda_function.zip      # Zipped Lambda code for deployment
├── main.tf                      # Terraform configuration file
├── README.md                    # This README file
└── .gitignore                   # Ignored files (e.g., Terraform state, ZIP files)

Deployment Instructions
Prerequisites
1. Install AWS CLI and configure it with your credentials.
2. Install Terraform (v1.x or later).
3. Package your Lambda function:

cd lambda
zip lambda_function.zip lambda_function.py

Steps

Steps to Configure Custom Domain Names and Latency-Based Routing
1. Create Custom Domain Names in API Gateway
Follow these steps for both regions (us-east-1 and ap-south-1):
- Navigate to API Gateway in the AWS Management Console.
- Select Custom Domain Names from the left-hand menu.
- Click Create and provide:
    Domain name: e.g., api.example.com.
    Certificate: Use an existing ACM certificate or request one for your domain.

After creating the custom domain name:
- Note the API Gateway domain name (e.g., abcd1234.execute-api.us-east-1.amazonaws.com).

2. Map APIs to Custom Domain Names
In the Custom Domain Names section, select the domain you just created.
- Click Create API Mapping and:
- Choose the API you deployed (e.g., MultiRegionAPI-East).
- Specify the Stage (e.g., prod).

Repeat the process for the API in ap-south-1.
3. Set Up Route53 Latency-Based Routing

- Navigate to Route53 in the AWS Management Console.
- Select your hosted zone (e.g., example.com).
- Create an A Record for api.example.com:
- Name: api (or leave blank for the root domain).
- Alias: Yes.
- Target: Choose the API Gateway domain name for us-east-1.
- Routing Policy: Latency.
- Region: North America (us-east-1).

Create another A Record for api.example.com:
- Name: api (or leave blank for the root domain).
- Alias: Yes.
- Target: Choose the API Gateway domain name for ap-south-1.
- Routing Policy: Latency.
- Region: Asia Pacific (ap-south-1).

Also, don't forget to create a custom domain name for your API in API Gateway.

Clone the Repository:
git clone https://github.com/yourusername/multi-region-api-deployment.git
cd multi-region-api-deployment

Initialize Terraform:
terraform init

Deploy the Infrastructure:
terraform apply
Confirm the plan and wait for resources to be created.

Set Up Route53 Latency-Based Routing:

Add latency records in Route53 for the API endpoints in us-east-1 and ap-south-1.

Testing
Use a tool like curl or Postman to test your API:
curl https://<your-route53-domain-name>/lambda
The response should indicate the AWS region handling the request (us-east-1 or ap-south-1).

Cleaning Up
To remove all resources:
terraform destroy

Notes
- Ensure the lambda/lambda_function.zip file is up-to-date before running terraform apply.
- Adjust the Lambda function and Terraform configuration (main.tf) as needed for your use case.

License
This project is licensed under the MIT License.