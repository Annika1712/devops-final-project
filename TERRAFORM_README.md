# Infrastructure as a Code with Terraform

### Storage resources (S3 bucket, DynamoDB):

In the root directory of the project execute the command:

`cd terraform/s3bucket_dynamo`

`terraform init`
`terraform plan`
`terraform apply --auto-approve`

This will create the s3 bucket and dynamodb for sharing the terraform state. With a shared terraform state, everyone can apply changes to terraform to make sure an up-to-date EKS environment is running.

### Networking resources (VPC, subnets, EKS):

In the root directory of the project execute the command:

`cd terraform`

`terraform init`
`terraform plan`
`terraform apply --auto-approve`

Before you run `terraform apply --auto-approve` make sure that you have helm installed on your computer, for instructions check: https://helm.sh/docs/intro/install/

With running terraform you first create an eks cluster in AWS with vpc, and the right permissions included. Second it will create all the necessary components inside kubernetes (e.g. namespaces, ingressclass, storageclass, etc.). Inside kubernetes the following controllers will be created.
- Ingress with AWS ELB, to support access from the internet
- Storage with AWS EBS, to support persistent volumes
- Prometheus and Grafana, this will be installed inside the cluster in a dedicated namespace called 'monitoring'
