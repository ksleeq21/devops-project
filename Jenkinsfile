pipeline {
    agent any
    environment {
        REGISTRY = 'ksleeq21/devops-project'
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
                sh "docker build . -t ${REGISTRY}"
                sh "docker image ls"
                // script {
                //     DOCKER_IMAGE = docker.build REGISTRY + ":latest"
                // }
            }
        }
        stage('Deploy Docker Image') {
            steps {
                withDockerRegistry([credentialsId: REGISTRY_CREDENTIAL_ID, url: ""]) {
                    sh "docker push ${REGISTRY}"
                }
                // script {
                //     docker.withRegistry('', REGISTRY_CREDENTIAL_ID)
                //     DOCKER_IMAGE.push()
                // }
            }
        }
        stage('Remove Unused docker image') {
            steps {
                sh "docker rmi $REGISTRY"
            }
        }
     }
}

// def get_docker_tag() {
//     def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
//     return tag
// }