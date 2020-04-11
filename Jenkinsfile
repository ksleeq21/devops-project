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
    }
    stages {
        // stage("Lint") {
        //     steps {
        //         sh "npm run lint"
        //     }
        // }
        // stage("Test") {
        //     steps {
        //         sh "npm test"
        //     }
        // }
        // stage("Build Docker Image") {
        //     steps {
        //         sh "docker build . -t ${IMAGE_URL}"
        //         sh "docker image ls"
        //     }
        // }
        // stage("Push Docker Image") {
        //     steps {
        //         withDockerRegistry([credentialsId: REGISTRY_CREDENTIAL_ID, url: ""]) {
        //             sh "docker push ${IMAGE_URL}"
        //         }
        //     }
        // }
        // stage("Remove Unused docker image") {
        //     when {
        //         branch "production"  
        //     }
        //     steps {
        //         sh "docker rmi ${IMAGE_URL}"
        //         sh "docker image ls"
        //     }
        // }
        stage("[Production] Deploy for production") {
            // when {
            //     branch "production"  
            // }
            steps {
                sh './scripts/update-version.sh ${DEPLOYMENT_NAME} ./config/${DEPLOYMENT_FILE} ${VERSION}'
                sshagent(['kops-server']) {
                    sh "scp -o StrictHostKeyChecking=no ./config/${DEPLOYMENT_FILE} ubuntu@ec2-34-219-4-55.us-west-2.compute.amazonaws.com:~/"
                    sh "scp -o StrictHostKeyChecking=no ./config/${DEPLOYMENT_FILE} ubuntu@ec2-34-219-4-55.us-west-2.compute.amazonaws.com:~/"
                    sh "ssh ubuntu@ec2-34-219-4-55.us-west-2.compute.amazonaws.com kubectl apply -f ${DEPLOYMENT_FILE}"
                    sh "ssh ubuntu@ec2-34-219-4-55.us-west-2.compute.amazonaws.com kubectl apply -f ${SERVICE_NAME}"
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