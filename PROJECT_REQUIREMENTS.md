<!-- Final Project: End-to-End DevOps Deployment -->

## Lesson Overview :pencil2:

In this project, we will focus on the hands-on implementation of the learnings throughout this program, where you will gain practical insights while setting up the entire DevOps cycle and deploying applications using acquired best practices. 

<br>

## Learning Objectives :notebook:

By the end of this project, you will: 

1. Apply DevOps practices to a real-world project in a production environment.
2. Build an effective CI/CD pipeline to automate delivery.
3. Automate provisioning, configuration and infrastructure management using Terraform and Ansible. 
4. Deploy and manage containerized applications using Kubernetes. 
5. Integrate applications with Managed Kubernetes Service and other cloud services
6. Set up monitoring and create dashboards using Grafana and Prometheus
7. Resolve issues arising during the entire cycle using best practices

<br>

## Project Highlights :key:

### Product Management:

1. This capstone project is a team project, where you will assume roles and work as a scrum team. 
2. The following indicators will be helpful for the successful completion of your project:         
    - The duration of one Sprint Cycle is 5 days. So, you will have three Sprint Cycles for this project.
    - Start with identifying a Scrum Master within your team.
    - Make sure to follow all scrum events like Sprint, Sprint Planning, Daily Scrum, Sprint Review, Sprint Retrospection.
    - Plan a Sprint Review at the end of every Sprint Cycle.
3. Your instructor will be the product owner. If you have any questions regarding the requirements or deliverables, you can address them to the Product Owner.
4. **Suggestion:** Start with a Team Agreement 
    - Decide your working hours
    - Decide your definition of done
    - Decide your team’s way of work
    - Identify the time when you will have your scrum events like daily scrum, sprint review, and other scrum events 
5. We will make use of Azure Boards (or JIRA boards or any other similar tool) to manage work
6. Please ensure that you have your Daily Scrum and evening sync-up (daily retrospective) every day.
7. The final sprint review and respective presentations will be held on the last day of the project (during the second half).

<br>

### Pre-requisites

1. You can use any cloud of your choice (AWS, Azure or Hybrid). Make sure to have an account with free-trial or an account with enough credit.
2. Create a free account on the DockerHub registry. This account will be used to host docker images used in the project

### Web Application Introduction

This sample application is an Expense Tracker with four microservices, a backend built in node, frontend built with Next.js (Node based framework), along with a MongoDB database and Redis caching DB.

[Clone this repository and share it with the team](https://github.com/saurabhd2106/devops-final-project.git)

Your task is to build a solution for this application that is scalable and can support zero to thousands of users. 

### Make sure to use the following:

#### 1. Infrastructure as Code (IaC):

- Use Terraform, AWS CloudFormation, or another IaC tool to define your infrastructure.

#### 2. Your infrastructure should include:

- Compute resources (e.g., EC2 instances, Kubernetes clusters).
- Networking resources (e.g., VPC, subnets, security groups).
- Storage resources (e.g., S3 buckets, RDS instances).
- Continuous Integration/Continuous Deployment (CI/CD):

#### 3. Implement a CI/CD pipeline using tools such as Jenkins, GitLab CI, or GitHub Actions.

The pipeline should:
- Automatically build and test your application.
- Deploy the application to a staging environment.
- Deploy to production upon approval.

#### 4. Containerization and Orchestration:
- Containerize your application using Docker.
- Use Kubernetes or Docker Swarm for orchestration to ensure your application can scale horizontally.

#### 5. Monitoring and Logging:

- Implement monitoring using tools like Prometheus, Grafana, or AWS CloudWatch.

#### 6. Autoscaling:

- Configure autoscaling for your compute resources (e.g., AWS Auto Scaling groups, Kubernetes Horizontal Pod Autoscaler) to handle varying loads.

#### 7. Security and Compliance:

- Implement best security practices, including network security (firewalls, security groups), data encryption, and IAM policies.
- Ensure compliance with relevant standards (e.g., GDPR, HIPAA) as applicable.

### Deliverables:

#### 1. Infrastructure Code:

- Provide all IaC scripts and configuration files like Terraform scripts, AWS CloudFormation templates, Ansible playbooks, etc.
- Include documentation explaining the infrastructure setup and how to deploy it.

#### 2. CI/CD Pipeline Configuration:

- Provide the CI/CD pipeline configuration files like Jenkinsfile, GitHub Actions workflows, etc.
- Include detailed documentation on how to set up and use the pipeline.

#### 3. Application Containerization and Orchestration:

- Provide Dockerfiles and Kubernetes/Docker Swarm configuration files.
- Include documentation on how to build and deploy the containers.

#### 4. Monitoring and Logging Configuration:

- Provide configuration files for monitoring and logging tools, including Prometheus configuration, Grafana dashboards, ELK stack configuration, etc.
- Include documentation on how to set up and interpret the monitoring and logging data.

#### 5. Autoscaling Configuration:

- Provide configuration files or scripts for autoscaling.
- Include documentation explaining the autoscaling policies, criteria for scaling, how to simulate load to test autoscaling, commands to check the current scaling status, etc. 

#### 6. Security and Compliance Documentation:

- Provide a security overview document detailing the measures implemented.
- Include compliance checklists and how your solution adheres to them.

### Evaluation Criteria:

1. Scalability:

- The solution should handle increasing loads efficiently.
- Autoscaling should work as expected, without degrading performance.
- Infrastructure should be able to scale horizontally (adding more instances) or vertically (upgrading existing instances) as needed.

2. Reliability:

- The CI/CD pipeline should deploy the application without errors.
- Monitoring and logging should provide useful insights into the application’s health.
- The pipeline should be ready for smooth integration of new code and features.

3. Security:

- The solution should follow best security practices.
- Compliance with relevant standards should be documented.

4. Documentation:

- The documentation should be clear and comprehensive documentation for each component.
- Ease of understanding and reproducibility must be considered while documenting all components. 

<!-- ## Additional Resources :clipboard: 

If you would like to study these concepts before the class or would benefit from some remedial studying, please utilize the resources below: -->

<br>

**Good luck!**