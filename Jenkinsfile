pipeline {
    agent any
    environment {
        NAME = get_name()
        VERSION = get_version()
        SERVICE_NAME = "svc-${NAME}"
        DEPLOYMENT_NAME = "dp-${NAME}"
        DEPLOYMENT_FILE = "deployment.yaml"
        SERVICE_FILE = "service.yaml"
        REGISTRY = "ksleeq21/devops-project"
        IMAGE_URL = "${REGISTRY}:${VERSION}"
        REGISTRY_CREDENTIAL_ID = "dockerhub"
        DEPLOY_SCRIPT_FILENAME = "deploy-for-production.sh"
    }
    stages {
        stage("Lint JavaScript") {
            steps {
                sh "npm run lint"
            }
        }
        stage("Lint HTML") {
            steps {
                sh "npm run tidy"
            }
        }
        stage("Lint Dockerfile") {
            steps {
                sh "npm run hadolint"
            }
        }
        stage("Test") {
            steps {
                sh "npm test"
            }
        }
        stage("Build Docker Image") {
            steps {
                sh "docker build . -t ${IMAGE_URL}"
                sh "docker image ls"
            }
        }
        stage("Push Docker Image") {
            steps {
                withDockerRegistry([credentialsId: REGISTRY_CREDENTIAL_ID, url: ""]) {
                    sh "docker push ${IMAGE_URL}"
                }
            }
        }
        stage("Remove Unused docker image") {
            when {
                branch "production"  
            }
            steps {
                sh "docker rmi ${IMAGE_URL}"
                sh "docker image ls"
            }
        }
        stage("[Production] Deploy for production") {
            when {
                branch "production"  
            }
            steps {
                sshagent(['kops-server']) {
                    sh "scp -o StrictHostKeyChecking=no ./config/${DEPLOYMENT_FILE} ubuntu@ec2-34-219-4-55.us-west-2.compute.amazonaws.com:~/"
                    sh "scp -o StrictHostKeyChecking=no ./config/${SERVICE_FILE} ubuntu@ec2-34-219-4-55.us-west-2.compute.amazonaws.com:~/"
                    sh "scp -o StrictHostKeyChecking=no ./scripts/${DEPLOY_SCRIPT_FILENAME} ubuntu@ec2-34-219-4-55.us-west-2.compute.amazonaws.com:~/"
                    sh 'ssh ubuntu@ec2-34-219-4-55.us-west-2.compute.amazonaws.com sh ./${DEPLOY_SCRIPT_FILENAME} ${DEPLOYMENT_NAME} ${DEPLOYMENT_FILE} ${VERSION} ${SERVICE_NAME} ${SERVICE_FILE}'
                }
            }
        }
    }
}

def get_version() {
    def version = sh script: "jq -r .version package.json", returnStdout: true
    return version
}

def get_name() {
    def name = sh script: "jq -r .name package.json", returnStdout: true
    return name
}