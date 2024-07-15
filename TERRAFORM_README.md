# Infrastructure as a Code with Terraform

### Storage resources (S3 bucket, DynamoDB):

In the root directory of the project execute the command:

`cd terraform/s3bucket_dynamo`

`terraform init`
`terraform plan`
`terraform apply --auto-approve`


### Networking resources (VPC, subnets, EKS):

In the root directory of the project execute the command:

`cd terraform/project_infrastructure`

`terraform init`
`terraform plan`
`terraform apply --auto-approve`