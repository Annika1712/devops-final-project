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

Before you run it make sure that you have helm installed. The instructions are as follows:
'curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3'
'chmod 700 get_helm.sh'
'./get_helm.sh'
Or if you want to do it another way, you can find the website with the offical instructions: https://helm.sh/docs/intro/install/