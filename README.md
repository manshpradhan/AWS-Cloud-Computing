Multi-Region Deployment of AWS API Gateway Using Route53 Latency-Based Routing 🚀
Overview
This repository demonstrates how to set up a multi-region deployment for an AWS API Gateway using Route53 Latency-Based Routing to achieve high availability and low latency. It uses Terraform for infrastructure-as-code and AWS Lambda to handle requests in two AWS regions.

Architecture
The architecture includes the following components:

Regions:
us-east-1 (North America)
ap-south-1 (Asia-Pacific)
API Gateway: Serves as the front door for API requests.
Route53: Routes traffic to the region with the lowest latency.
AWS Lambda: Handles API requests in both regions.
Repository Structure
python
Copy code
├── lambda/
│   ├── lambda_function.py      # Your Lambda function code
│   └── lambda_function.zip     # Zipped Lambda code for deployment
├── main.tf                     # Terraform configuration file
├── README.md                   # This README file
└── .gitignore                  # Ignored files (e.g., Terraform state, ZIP files)
Deployment Instructions
Prerequisites
Before you begin, make sure to have the following tools installed and configured:

AWS CLI: Install and configure the AWS CLI with your credentials.
Terraform: Install Terraform (v1.x or later).
Step 1: Package your Lambda function
Navigate to the lambda folder and package your Lambda function into a zip file:

bash
Copy code
cd lambda
zip lambda_function.zip lambda_function.py
Step 2: Set Up Custom Domain Names and Latency-Based Routing
1. Create Custom Domain Names in API Gateway
Follow these steps for both regions (us-east-1 and ap-south-1):

Navigate to API Gateway in the AWS Management Console.
Select Custom Domain Names from the left-hand menu.
Click Create and provide the following:
Domain name: e.g., api.example.com
Certificate: Use an existing ACM certificate or request one for your domain.
After creating the custom domain name, note the API Gateway domain name (e.g., abcd1234.execute-api.us-east-1.amazonaws.com).

2. Map APIs to Custom Domain Names
In the Custom Domain Names section, select the domain you just created.
Click Create API Mapping and:
Choose the API you deployed (e.g., MultiRegionAPI-East).
Specify the Stage (e.g., prod).
Repeat this process for the API in ap-south-1.

3. Set Up Route53 Latency-Based Routing
Navigate to Route53 in the AWS Management Console.
Select your hosted zone (e.g., example.com).
Create an A Record for api.example.com:
Name: api (or leave blank for the root domain).
Alias: Yes.
Target: Choose the API Gateway domain name for us-east-1.
Routing Policy: Latency.
Region: North America (us-east-1).
Create another A Record for api.example.com:
Name: api (or leave blank for the root domain).
Alias: Yes.
Target: Choose the API Gateway domain name for ap-south-1.
Routing Policy: Latency.
Region: Asia Pacific (ap-south-1).
Additionally, don't forget to create a custom domain name for your API in API Gateway.

Step 3: Initialize and Deploy with Terraform
Clone the repository:

bash
Copy code
git clone git@github.com:manshpradhan/AWS-Cloud-Computing.git
Navigate into the repository folder.

Initialize Terraform:

bash
Copy code
terraform init
Deploy the infrastructure:

bash
Copy code
terraform apply
Confirm the plan and wait for resources to be created.

Step 4: Set Up Route53 Latency-Based Routing
Add latency records in Route53 for the API endpoints in us-east-1 and ap-south-1.
Step 5: Test the Deployment
You can test the API using a tool like curl or Postman:

bash
Copy code
curl https://api.example.com/lambda
The response should indicate the AWS region (either us-east-1 or ap-south-1) handling the request based on the lowest latency.

Step 6: Clean Up
To remove all resources, run:

bash
Copy code
terraform destroy
Notes
Ensure the lambda/lambda_function.zip file is up-to-date before running terraform apply.
Adjust the Lambda function and Terraform configuration (main.tf) as needed for your specific use case.
License
This project is licensed under the MIT License.
