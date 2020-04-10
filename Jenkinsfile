pipeline {
    agent any
    environment {
        NAME = get_name()
        VERSION = get_version()
        NAMESPACE = "ns-${NAME}"
        SERVICE_NAME = "svc-${NAME}"
        DEPLOYMENT_NAME = "dp-{NAME}-${VERSION}"
        REGISTRY = "ksleeq21/devops-project"
        IMAGE_URL = "${REGISTRY}:${VERSION}"
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
                sh "sh ./scripts/deploy-for-production.sh ${NAMESPACE} ${SERVICE_NAME} ${DEPLOYMENT_NAME} ${VERSION}"
            }
        }
        stage("Remove Unused docker image") {
            steps {
                sh "docker rmi ${IMAGE_URL}"
                sh "docker image ls"
            }
        }
    }
}

def get_version() {
    // def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    def version = sh script: "jq -r .version package.json", returnStdout: true
    return version
}

def get_name() {
    def name = sh script: "jq -r .name package.json", returnStdout: true
    return name
}