pipeline {
    agent any
    environment {
        REGISTRY = 'ksleeq21/devops-project'
        REGISTRY_CREDENTIAL = 'dockerhub'
        DOCKER_IMAGE = ''
    }
    stages {
        stage('Lint') {
            steps {
                sh 'tidy -q -e ./public/*.html'
                sh 'eslint .'
                sh 'hadolint Dockerfile'
            }
        }
        stage('Build Docker Image') {
            steps {
                DOCKER_IMAGE = docker.build REGISTRY + ":latest"
                // sh "docker build . -t ksleeq21/devops-project"
                // sh "docker image ls"
            }
        }
        stage('Deploy image') {
            steps {
                script {
                    docker.withRegistry('', REGISTRY_CREDENTIAL)
                    DOCKER_IMAGE.push()
                }
            }
        }
        stage('Remove Unused docker image') {
            steps {
                sh "docker rmi $REGISTRY:latest"
            }
        }
        //  stage('Upload to AWS') {
        //       steps {
        //           withAWS(region:'us-west-2') {
        //           sh 'echo "Uploading content with AWS creds"'
        //               s3Upload(pathStyleAccessEnabled: true, payloadSigningEnabled: true, file:'index.html', bucket:'static-jenkins-pipeline-kangsan')
        //           }
        //       }
        //  }
     }
}

def get_docker_tag() {
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}