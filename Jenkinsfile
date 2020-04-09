pipeline {
    agent any
    environment {
        REGISTRY = 'ksleeq21/devops-project'
        DOCKER_TAG = get_docker_tag()
        IMAGE_URL = "${REGISTRY}:${DOCKER_TAG}"
        REGISTRY_CREDENTIAL_ID = 'dockerhub'
    }
    stages {
        stage("Lint") {
            steps {
                sh "tidy -q -e ./public/*.html"
                sh "eslint ."
                sh "hadolint Dockerfile"
            }
        }
        stage("Build Docker Image") {
            steps {
                sh "docker build . -t ${IMAGE_URL}"
                sh "docker image ls"
            }
        }
        stage('Deploy Docker Image') {
            steps {
                withDockerRegistry([credentialsId: REGISTRY_CREDENTIAL_ID, url: ""]) {
                    sh "docker push ${IMAGE_URL}"
                }
            }
        }
        stage('Remove Unused docker image') {
            steps {
                sh "docker rmi ${IMAGE_URL}"
            }
        }
    }
}

def get_docker_tag() {
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}