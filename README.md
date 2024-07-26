# [Final project](./PROJECT_REQUIREMENTS.md): End-to-End DevOps Deployment 

In this project we'll build a solution for sample application (Expense Tracker) with four microservices, a backend built in node, frontend built with Next.js (Node based framework), along with a MongoDB database and Redis caching DB that is scalable and can support zero to thousands of users.

#### 1. [Infrastructure](./TERRAFORM_README.md) as Code (IaC):

- Used Terraform IaC tool to define our infrastructure.

#### 2. [CI/CD Pipeline](./CICD_README.md) Configuration:

- Used Github Actions to deploy the 4-tier application

#### 3. [Application Containerization and Orchestration](./K8s_README.md):

- Used docker for Application Containerization
- Used AWS EKS (Kubernetes) for Application Orchestration

#### 4. [Monitoring and Logging Configuration](./monitoring_README.md):

- Used Grafana and Prometheus for logging and monitoring

#### 5. Autoscaling Configuration:

- Used managed nodegroups for autoscaling
