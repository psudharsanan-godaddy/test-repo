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
          sh "mvn clean verify -f test/pom.xml"
        }
      }
    }
  }
  post {
    always {
      notifyFinalResult()
    }
  }
}


def notifyFinalResult() {
  if((env.BRANCH_NAME == 'master')) {
    def notificationStatusColor = 'danger';
    if(currentBuild.currentResult == 'SUCCESS'){
      notificationStatusColor = 'good'
    }
    slackSend (color: notificationStatusColor, message: "${currentBuild.currentResult}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (<${env.BUILD_URL}|Open>)")
  }
}
