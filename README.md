# Daily Emails: a Terraform learning project

This is a small project I built to learn Terraform by deploying a scheduled AWS Lambda that sends a short, affectionate email to Vera.

It uses Terraform to create the IAM roles, Lambda, and EventBridge Scheduler; Node.js 22 for the Lambda runtime; and Amazon SES v2 to send the email.

## What I Learned

- Terraform separates reusable infrastructure into modules. The root configuration in `main.tf` composes the `modules/email-lambda` module, while the module creates the Lambda and its IAM permissions.
- Input variables keep account-specific values, such as sender and recipient addresses, out of the Terraform configuration. `variables.tf` declares them and the ignored `variables.tfvars` file supplies their values at deploy time.
- A Lambda needs an execution role. This project grants the basic CloudWatch Logs permissions and a narrowly focused policy to send email through SES.
- EventBridge Scheduler invokes the Lambda on a timezone-aware daily schedule and assumes its own role with permission to invoke only this function.
- Lambda deployment code must be packaged before Terraform applies the infrastructure. The `email-lambda.zip` archive is the artifact Terraform uploads.
- A Lambda does not need to be in a VPC just because it uses AWS services or talks to the internet. This function is intentionally outside a VPC because it only reaches SES and CloudWatch Logs. A VPC is useful when it must reach private resources, such as a private database.

## What It Does

The Lambda picks a random message from a small list in [email-lambda/index.js](email-lambda/index.js) and sends it with this setup:

- From: `baby@nguyenbytes.com`
- To: `vera.zh195@gmail.com`
- Subject: `Thinking of you`

Terraform also creates an EventBridge Scheduler schedule named `vera-daily-email-daily`.
It invokes the Lambda every day at 5:30 PM in the `America/Los_Angeles` timezone.

## Project Layout

```text
.
|-- email-lambda/
|   |-- index.js
|   |-- package.json
|   `-- package-lock.json
|-- modules/
|   `-- email-lambda/
|       `-- main.tf
|-- email-lambda.zip
|-- main.tf
`-- README.md
```

## Deploy It

1. Install email Lambda dependencies:

```bash
cd email-lambda
npm install
```

2. Build the email deployment ZIP:

```bash
npm run zip
```

3. Plan or apply Terraform with the local variables file:

```bash
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars
```

## Important Notes

- SES must be able to send from `baby@nguyenbytes.com`.
- If the AWS account is still in SES sandbox mode, the recipient usually also needs to be verified.
- The sender and recipient addresses come from `variables.tfvars`; the subject and message list are in `email-lambda/index.js`.
- `email-lambda.zip` must exist before infrastructure updates the function code.

## Quick Changes

Update [email-lambda/index.js](email-lambda/index.js) if you want different behavior:

- subject line
- message list

Update `variables.tfvars` to change the sender or recipient email address.
