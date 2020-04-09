pipeline {
    agent any
    environment {
        DOCKER_TAG = get_docker_tag()
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
                sh "docker build . -t ksleeq21/devops-project"
                sh "docker image ls"
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