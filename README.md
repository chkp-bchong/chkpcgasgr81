# Check Point CloudGuard Auto Scaling Group on R81
## Introduction 
This is a sample terraform deployment for demonstration purpose. The terraform script will deploy Check Point CloudGuard Security Gateway ASG and Security Management with Cloud Formation on AWS. It will also provision the required web servers and underlying VPCs, subnets, route tables, etc. The terraform deployment will take about 20 minutes, and the ALB URL will be available on the console as an output. 

## Pre-requisite 
1. AWS Account

2. ssh key pair to access your instances after deployment. the name of the key pair is required on variables.tf

3. IAM user & security credenntials for terraform access to deploy in your cloud account. AWS credentials (access key & secret access key) are required to be installed on your endpoint or terraform machine. 

4. Subscription to Check Point Security Management Server, Security Gateway and Ubuntu.
https://aws.amazon.com/marketplace/pp/B07LB3YN9P?qid=1610950721927&sr=0-1&ref_=srh_res_product_title
https://aws.amazon.com/marketplace/pp/B07KSBV1MM?qid=1610950721927&sr=0-2&ref_=srh_res_product_title
https://aws.amazon.com/marketplace/pp/B07CQ33QKV?qid=1610950808328&sr=0-1&ref_=srh_res_product_title

5. Terraform installed on your endpoint or Terraform machine.

## Steps to deploy in your AWS account
1. Configure or change some of the default value on variables.tf. Mandatory items to change for your cloud environment:
   - region
   - key_name
   - password_hash (leave it blank if not required)

2. Run "terraform init" for first time initialization and terraform plugin download.

3. Run "terraform plan" to ensure you have the right credentials to deploy in your AWS account.

4. Run "terraform apply" to deploy this in your AWS account. Type "yes" when being asked to proceed with the changes.

## Steps to destroy the infrastructure in your AWS account
1. Run "terraform destroy" to destroy the demo setup in your AWS account. Type "yes" when being asked to proceed with the changes.

## References
Security Gateway Auto Scaling

https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk112575


Security Management Server

https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk130372



