pipeline {
     agent any
     stages {
         stage('Lint HTML') {
            steps {
                sh 'tidy -q -e *.html'
            }
         }
         stage('Lint JavaScript') {
             steps {
                 sh 'eslint .'
             }
         }
         stage('Lint Dockerfile') {
             sh 'hadolint Dockerfile'
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
