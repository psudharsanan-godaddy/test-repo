pipeline {
  agent {
    label 'cp-ci-slave'
  }

  tools {
    maven 'Maven3-latest'
    jdk 'temurin-17.0.1+12'
  }

  environment {
    BUILD_ENV='ci'
    APP_NAME='commerce-app-helm-chart'
  }

  stages {
    stage('Build') {
      steps {
        script {
          sh "cd test"
          sh "mvn clean verify"
        }
      }
    }
  }
  post {
    always {
      notifyFinalResult(sentNotifyStart)
    }
  }
}

def notifyFinalResult(def sentNotifyStart) {
/*   if((env.BRANCH_NAME == 'master' || env.BRANCH_NAME == 'release') && sentNotifyStart == true) {
    def notificationStatusColor = 'danger';
    if(currentBuild.currentResult == 'SUCCESS'){
      notificationStatusColor = 'good'
    }
    slackSend (color: notificationStatusColor, message: "${currentBuild.currentResult}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (<${env.BUILD_URL}|Open>)")
  } */
}

def notifyStart() {
/*   if(env.BRANCH_NAME == 'master' || env.BRANCH_NAME == 'release') {
    slackSend (color: '#FFFF00', message: "STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (<${env.BUILD_URL}|Open>)")
  } */
}
