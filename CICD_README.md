# CI/CD in Github Actions
The pipeline consists of 2 phases: Build/Publish and Deploy. Build/Publish gets triggered on a push to the branch (devs, prod, stag, etc.) and depending on in which folder you made changes either frontend or backend will get published to Docker Hub. 
After completion of either of those workflows, the deploy workflow gets triggered. You can also trigger the deploy workflow manually should you want to.

## prerequisites
For Docker to know which tags to apply use 'git tag -a' and 'git push origin tag <tag_name>'

Before you start the workflow, make sure you have all variables. They are preset, but the following variables need to be present for the workflow to complete successfully.
In secrets:
DOCKERHUB_USERNAME
DOCKERHUB_TOKEN
AWS_EKS_ROLE_ARN

In variables:
EKS_CLUSTER_NAME
AWS_REGION

The ENVIRONMENT variable is set as an environment variable for production, staging and development and it determines the namespae in which the application gets deployed.