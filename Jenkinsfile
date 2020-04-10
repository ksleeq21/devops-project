pipeline {
    agent any
    environment {
        NAMESPACE = "webapp-ns"
        SERVICE_NAME = "webapp-svc"
        DEPLOYMENT_NAME = "webapp-dp"
        REGISTRY = "ksleeq21/devops-project"
        DOCKER_TAG = get_docker_tag()
        IMAGE_URL = "${REGISTRY}:${DOCKER_TAG}"
        REGISTRY_CREDENTIAL_ID = 'dockerhub'
    }
    stages {
        stage("Lint") {
            steps {
                sh "npm run lint"
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
        stage("Deploy for production") {
            when {
                branch "master"  
            }
            steps {
                sh "./scripts/deploy-for-production.sh ${NAMESPACE} ${SERVICE_NAME} ${DEPLOYMENT_NAME} ${DOCKER_TAG}"
                // sh "docker stop $(docker ps -a -q)"
                // sh "docker rm $(docker ps -a -q)"
                // sh "docker rmi $(docker images -a -q)"
                // sh "docker rmi ${IMAGE_URL}"
                // sh "docker image ls"
            }
        }
        stage("Remove Unused docker image") {
            steps {
                // sh "docker stop $(docker ps -a -q)"
                // sh "docker rm $(docker ps -a -q)"
                // sh "docker rmi $(docker images -a -q)"
                sh "docker rmi ${IMAGE_URL}"
                sh "docker rmi $(docker images |grep 'node:12.16.1-alpine3.9')"
                sh "docker image ls"
            }
        }
    }
}

def get_docker_tag() {
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}