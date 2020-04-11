pipeline {
    agent any
    environment {
        NAME = get_name()
        VERSION = get_version()
        SERVICE_NAME = "svc-${NAME}"
        DEPLOYMENT_NAME = "dp-${NAME}"
        DEPLOYMENT_FILE = "./config/deployment.yaml"
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
                // sh './scripts/deploy-for-production.sh ${SERVICE_NAME} ${DEPLOYMENT_NAME} ${VERSION} ${DEPLOYMENT_FILE}'
                // sh 'kubectl apply -f ./config/deployment-test.yaml'
                sshagent(['kops-server']) {
                    sh "scp -o StrictHostKeyChecking=no ./config/deployment-101.yaml  ubuntu@ec2-34-219-4-55.us-west-2.compute.amazonaws.com:~/"
                    sh "scp -o StrictHostKeyChecking=no ./config/service.yaml ubuntu@ec2-34-219-4-55.us-west-2.compute.amazonaws.com:~/"
                    script {
                        try {
                            sh "ssh -i ~/jump-bo.pem ubuntu@ec2-34-219-4-55.us-west-2.compute.amazonaws.com kubectl apply -f deployment-101.yaml"
                            sh "ssh -i ~/jump-bo.pem ubuntu@ec2-34-219-4-55.us-west-2.compute.amazonaws.com kubectl apply -f service.yaml"
                        } catch (error) {
                            sh "ssh -i ~/jump-bo.pem ubuntu@ec2-34-219-4-55.us-west-2.compute.amazonaws.com kubectl apply -f deployment-101.yaml"
                            sh "ssh -i ~/jump-bo.pem ubuntu@ec2-34-219-4-55.us-west-2.compute.amazonaws.com kubectl apply -f service.yaml"
                        }
                    }
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