# 📧 Daily Emails: a Terraform learning project

A small personal project for learning Terraform by building a daily email service. An Amazon EventBridge Scheduler triggers a Lambda function daily at 5:30 PM, which sends an email through Amazon SES.

## 🗺️ Overview
![Daily email system diagram](daily-emails.png)

## 🎯 Goals of this Project:
- To understand how to effectively use Terraform to provision, update, and destroy cloud infrastructure
- Understanding basics of secure serverless architechure
- How to properly provision a Terraform stack to be reproducible

## 🧰 Key Skills Used

- <img src="https://cdn.simpleicons.org/terraform/7B42BC" alt="Terraform" width="20" height="20"> **Terraform**
    - Variables 
    - State
    - Modules
    - Providers and version constraints
    - Resources and data sources
    - Outputs
    - Dependency management
    - Planning and applying infrastructure changes
- <img src="https://cdn.simpleicons.org/amazonaws/FF9900" alt="AWS" width="20" height="20"> **AWS**
    - EventBridge 
    - Lambda 
    - Simple Email Service
    - IAM Roles

## 💭 Reflection / What I Learned:

### ☁️ Getting Used to Cloud Configuration

Before learning about Terraform I would primarily configure AWS resources using the AWS console. It was very tedious and very much a pain to work with. But learning how to use Terraform effectively even at a basic level is game changing for me. I am now now able to provision cloud resources with a few lines of configuration and a few commands rather than painstakingly manually going through the AWS Console! Using the Cloud used to be kind of terrifiying to me because I would always be charged for things I never knew about. Even just keeping resources you don't use alive costs money! Now I am able to keep costs low and have a lot more agency in my Cloud Automation Engineering career Journey.

### ⚡ Appreciating Serverless Architecture

One thing I really appreciate about AWS is that they were the first to promote serverless architecture. The more I learn about systems design the more I see why companies like AWS and other cloud providers are so successful. Keeping a server from crashing is hard job all on its own, making sure it handles requests with queues, load balancers, etc.. is a whole other beast! Having services like SQS and ALB are revolutionary. For a "reasonable" fee, you can have AWS do the heavy lifting on parts of your infrastructure you are not comportable with. I know a lot of people in the tech industry have a lot of opinions about Cloud Providers and how tricky they are to work with, but it is still loads better than having to actually manage physical machines!

### 🔐 Security Concerns

One thing I was always had pains with in AWS was IAM roles. Manually creating them using the AWS Console took time out of my day that I could've been using to do anything else. Many people who are so called "indie developers" hate them with a passion. But with Terraform, creating and provisioning them has never been easier. When someone starts to see software in the bigger picture and not just developing features, security becomes such an much bigger issue. I think many people instictively understand the principle of least privelage, but it is actually hard to pin point how that actually works. tThat is where my expertise comes in!

### ✨ Final Thoughts

I was getting really burnt out being just a Full Stack Developer. Truth be told that kind of job doesnt exist anymore. Code is now so easily created by AI, being able to produce code itself means nothing. A lot of the code in this repository is AI generated, but I still needed to read through the Terraform documentation, watch tutorials, and play with it in the terminal to really understand it. This project is definitely the start of a new chapter in my Career Journey!

## 🚀 Possible Next Steps!
- Add a dedicated VPC and an RDS or DynamoDB databse
- Add another Lambda Function that gets a random message from the newly created database and send message to the current Lambda that sends it using SES
- Instead of having event bridge trigger the lambda, create step function that triggers the database lambda, which sends the message to the SES Lambda
- Since RDS or DynamoDB would be a private databse, put all resources into their proper private and Public subnets within the VPC

## 🛠️ Do It Yourself!

### ✅ Prerequisites

- Terraform
- AWS CLI
- An email address or domain verified in Amazon SES

1. Clone this repository and enter the project directory.

   ```bash
   git clone <repository-url>
   cd daily-email
   ```

2. Create your local variables file from the provided template, then update its placeholder values.

   ```bash
   cp example.tfvars variables.tfvars
   ```

   Set `from_email` to an address that uses your SES-verified identity.

3. Install dependencies and create the Lambda deployment package.

   ```bash
   cd email-lambda
   npm install
   npm run zip
   cd ..
   ```

4. Initialize Terraform.

   ```bash
   terraform init
   ```

5. Optionally format, validate, and review the proposed changes.

   ```bash
   terraform fmt -check -recursive
   terraform validate
   terraform plan -var-file=variables.tfvars
   ```

6. Provision the project.

   ```bash
   terraform apply -var-file=variables.tfvars -auto-approve
   ```

7. Remove the project when finished to avoid ongoing AWS charges.

   ```bash
   terraform destroy -var-file=variables.tfvars -auto-approve
   ```
