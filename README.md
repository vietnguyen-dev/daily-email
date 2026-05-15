# Vera Emails

Small project for sending a short, affectionate email to Vera.

It uses:

- Terraform to create the IAM role and Lambda
- Node.js 22 for the Lambda runtime
- Amazon SES v2 to send the email

## What It Does

The Lambda picks a random message from a small list in [email-lambda/index.js](/home/tom/Desktop/vera-emails/email-lambda/index.js:1) and sends it with this setup:

- From: `baby@nguyenbytes.com`
- To: `vera.zh195@gmail.com`
- Subject: `Thinking of you`

## Project Layout

```text
.
|-- email-lambda/
|   |-- index.js
|   |-- package.json
|   `-- package-lock.json
|-- email-lambda.zip
|-- main.tf
`-- README.md
```

## Basic Flow

1. Install Lambda dependencies:

```bash
cd email-lambda
npm install
```

2. Build the deployment ZIP:

```bash
npm run zip
```

## Important Notes

- SES must be able to send from `baby@nguyenbytes.com`.
- If the AWS account is still in SES sandbox mode, the recipient usually also needs to be verified.
- The email addresses and messages are currently hardcoded in `email-lambda/index.js`.
- `email-lambda.zip` must exist before infrastructure updates the function code.

## Quick Changes

Update these values in [email-lambda/index.js](/home/tom/Desktop/vera-emails/email-lambda/index.js:5) if you want different behavior:

- sender email
- recipient email
- subject line
- message list
