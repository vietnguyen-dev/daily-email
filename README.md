# Daily Emails: a Terraform learning project

A small personal project for learning Terraform by building a daily email service. An Amazon EventBridge Scheduler triggers a Lambda function daily at 5:30 PM, which sends an email through Amazon SES.

## Overview
![Daily email system diagram](daily-emails.png)

## Goals of this Project:
- To understand how to effectively use Terraform to provision, update, and destroy cloud infrastructure
- Understanding basics of secure serverless architechure
- How to properly provision a Terraform stack to be reproducible

## Key Skills Used 
- Terraform 
    - Variables 
    - State
    - Modules
    - Providers and version constraints
    - Resources and data sources
    - Outputs
    - Dependency management
    - Planning and applying infrastructure changes
- AWS 
    - EventBridge 
    - Lambda 
    - Simple Email Service
    - IAM Roles

## Reflection / What I Learned:
- Getting Used to Cloud Configuration
    Before learning about Terraform I would primarily configure AWS resources using the AWS console. It was very tedious and very much a pain to work with. But learning how to use Terraform effectively even at a basic level is game changing for me. I am now now able to provision cloud resources with a few lines of configuration and a few commands rather than painstakingly manually going through the AWS Console! Using the Cloud used to be kind of terrifiying to me because I would always be charged for things I never knew about. Even just keeping resources you don't use alive costs money! Now I am able to keep costs low and have a lot more agency in my Cloud Automation Engineering career Journey.

- Serverless Architechure
One thing I really appreciate about AWS is that they were the first to promote Serverless Architechure. 

## Possible Next steps!
- Add automated tests and deployment checks.
- Move personal settings into a safer configuration workflow.
- Experiment with new email content and schedule options.


## Do it Yourself! 
- Add automated tests and deployment checks.
- Move personal settings into a safer configuration workflow.
- Experiment with new email content and schedule options.
