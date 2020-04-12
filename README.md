# DevOps Project

*Capstone project for Udacity DevOps Nanodegree program*

This project provide a simple web page. 

--- 

## Set up a Jenkins Server & a Kops Server

To provision Jenkins and Kops servers run a script. This script creates a Jenkins server and Kops server that controls kubectl operations.

```
./scripts/create.sh jenkins-server ./templates/jenkins-server.yaml ./templates/jenkins-server-parameters.json
```

Jenkins configuration
- Install plugins for Jenkins operations
- Install packages for Jenkins operations
- Store credentials for connecting AWS, DockerHub, and Kops server

Kops configuration
- Install packages for Kubernetes and EKS Cluster
- Create a SSH key pair using `ssh-keygen -m PEM` to connect to EKS Linux Worker Nodes

---

## Set up EKS cluster and nodegroup

To create EKS cluster and nodegroup login to Kops server and run eksctl commands. This will create Cloudformation stacks `eksctl-devops-cluster` and `eksctl-devops-nodegroup-standard-workers`.

Command for EKS Cluster
```
eksctl create cluster \
 --name devops \
 --region us-west-2 \
 --without-nodegroup
```

Command for EKS nodegroup
```
eksctl create nodegroup \
--cluster devops \
--version auto \
--name standard-workers \
--node-type t3.medium \
--nodes 3 \
--nodes-min 1 \
--nodes-max 4 \
--ssh-access \
--ssh-public-key /home/ubuntu/.ssh/id_rsa.pub \
--managed
```

---

## Deployment

Jenkins pipeline provides Blue-Green Deployment. When a pipeline is kicked in Jenkins runs `./scripts/deploy-for-production.sh` with some parameters to begin Blue-Green Deployment.

Parameters of `deploy-for-production.sh`
- DEPLOYMENT_NAME: Name of deployment 
- DEPLOYMENT_FILE: Template of k8s deployment file
- VERSION: Version of application
- SERVICE_NAME: Name of service
- SERVICE_FILE: Template of k8s deployment file

Functionalities of `deploy-for-production.sh`
- Update deployment.yaml and service.yaml with parameters
- Check current deployments to prevent a duplicate
- Apply deployment and service
- Check deployment readiness
- Update service spec
- Check health of service
- Delete Blue Deployment

---

## Screenshots

- cfn-stack-jenkins-kops-servers.png: Cloudformation stack for provisioning jenkins server and kops server
- cfn-stack-eks-cluster-nodegroup.png: Cloudformation stack of EKS Cluster created by eksctl command
- jenkins-pipeline-devops-project.png: Jenkins Blue Ocean dashboard for devops project
- production-1.0.10-jenkins-pipeline.png: Jenkins build for version 1.0.10
- production-1.0.10-k8s.png: K8s outcome of version 1.0.10
- production-1.0.10-web.png: Web page of version 1.0.10
- production-1.0.11-jenkins-pipeline.png: Jenkins build for version 1.0.11
- production-1.0.11-k8s.png: K8s outcome of version 1.0.11
- production-1.0.11-web.png: Web page of version 1.0.11
- master-1.0.11-lint-fail.png: Build failure caused by eslint error
- master-1.0.11-lint-success.png:  Build success after fixing eslint error
- dockerhub-images.png: DockerHub repository for devops-project

--- 

## References

- [Jenkins SSH Agent](https://plugins.jenkins.io/ssh-agent/)
- [Getting Started with eksctl](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html)
- [Deploy to Kubernetes Cluster | CI/CD Kubernetes using Jenkins Pipeline](https://www.youtube.com/watch?v=naUhXrV_rRA&t=650s)
- [Blue/Green Deployments on Kubernetes](https://www.ianlewis.org/en/bluegreen-deployments-kubernetes)

