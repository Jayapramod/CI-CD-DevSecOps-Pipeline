pipeline {
  agent any

  environment {
    DOCKERHUB_CREDS = 'dockerhub-creds'
    SONAR_TOKEN = 'sonar-token'
    SONAR_SERVER = 'SonarQube'
    DOCKERHUB_NAMESPACE = 'jayapramod'
    EMAIL_RECIPIENTS = 'jayapramodmanikantan@gmail.com'

  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
      post {
        success {
          script {
            if (env.EMAIL_RECIPIENTS?.trim()) {
              emailext to: "${env.EMAIL_RECIPIENTS}",
                       subject: "✅ Stage Passed: Checkout - ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                       body: "Checkout stage completed successfully.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}"
            } else {
              emailext subject: "✅ Stage Passed: Checkout - ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                       body: "Checkout stage completed successfully.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}",
                       recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            }
          }
        }
        failure {
          script {
            if (env.EMAIL_RECIPIENTS?.trim()) {
              emailext to: "${env.EMAIL_RECIPIENTS}",
                       subject: "❌ Stage Failed: Checkout - ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                       body: "Checkout stage failed. Please check the console output.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}"
            } else {
              emailext subject: "❌ Stage Failed: Checkout - ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                       body: "Checkout stage failed. Please check the console output.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}",
                       recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            }
          }
        }
      }
    }

    stage('Build') {
      steps {
        sh 'mvn -B -DskipTests package'
      }
      post {
        success {
          script {
            if (env.EMAIL_RECIPIENTS?.trim()) {
              emailext to: "${env.EMAIL_RECIPIENTS}", subject: "✅ Stage Passed: Build - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Maven build completed successfully.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}"
            } else {
              emailext subject: "✅ Stage Passed: Build - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Maven build completed successfully.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}", recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            }
          }
        }
        failure {
          script {
            if (env.EMAIL_RECIPIENTS?.trim()) {
              emailext to: "${env.EMAIL_RECIPIENTS}", subject: "❌ Stage Failed: Build - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Maven build failed. Please check the console output.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}"
            } else {
              emailext subject: "❌ Stage Failed: Build - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Maven build failed. Please check the console output.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}", recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            }
          }
        }
      }
    }

    stage('Unit Tests') {
      steps {
        sh 'mvn test'
      }
      post {
        always {
          junit 'target/surefire-reports/*.xml'
        }
        success {
          script {
            if (env.EMAIL_RECIPIENTS?.trim()) {
              emailext to: "${env.EMAIL_RECIPIENTS}", subject: "✅ Stage Passed: Unit Tests - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Unit tests completed successfully.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}"
            } else {
              emailext subject: "✅ Stage Passed: Unit Tests - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Unit tests completed successfully.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}", recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            }
          }
        }
        failure {
          script {
            if (env.EMAIL_RECIPIENTS?.trim()) {
              emailext to: "${env.EMAIL_RECIPIENTS}", subject: "❌ Stage Failed: Unit Tests - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Unit tests failed. Please check the console output and test reports.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}"
            } else {
              emailext subject: "❌ Stage Failed: Unit Tests - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Unit tests failed. Please check the console output and test reports.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}", recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            }
          }
        }
      }
    }

    stage('SonarQube Analysis') {
      steps {
        withCredentials([string(credentialsId: env.SONAR_TOKEN, variable: 'SONAR_LOGIN')]) {
          withSonarQubeEnv(env.SONAR_SERVER) {
            script {
              def sonarUrl = env.SONAR_HOST_URL ?: 'http://sonarqube:9000'
              sh "echo 'Checking SonarQube connectivity to ${sonarUrl}'"
              sh "curl -sSf -u ${SONAR_LOGIN}: ${sonarUrl}/api/system/health || (echo 'ERROR: SonarQube not reachable or access denied at ${sonarUrl}' >&2; exit 1)"
              sh "mvn -B sonar:sonar -Dsonar.login=${SONAR_LOGIN} -Dsonar.host.url=${sonarUrl}"
            }
          }
        }
      }
      post {
        success {
          script {
            if (env.EMAIL_RECIPIENTS?.trim()) {
              emailext to: "${env.EMAIL_RECIPIENTS}", subject: "✅ Stage Passed: SonarQube Analysis - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "SonarQube code analysis completed successfully.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}"
            } else {
              emailext subject: "✅ Stage Passed: SonarQube Analysis - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "SonarQube code analysis completed successfully.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}", recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            }
          }
        }
        failure {
          script {
            if (env.EMAIL_RECIPIENTS?.trim()) {
              emailext to: "${env.EMAIL_RECIPIENTS}", subject: "❌ Stage Failed: SonarQube Analysis - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "SonarQube analysis failed. Please check the console output.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}"
            } else {
              emailext subject: "❌ Stage Failed: SonarQube Analysis - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "SonarQube analysis failed. Please check the console output.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}", recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            }
          }
        }
      }
    }

    stage('Quality Gate') {
      steps {
        timeout(time: 10, unit: 'MINUTES') {
          script {
            def qg = waitForQualityGate()
            if (qg.status != 'OK') {
              error "Pipeline aborted due to SonarQube quality gate: ${qg.status}"
            }
          }
        }
      }
      post {
        success {
          script {
            if (env.EMAIL_RECIPIENTS?.trim()) {
              emailext to: "${env.EMAIL_RECIPIENTS}", subject: "✅ Stage Passed: Quality Gate - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "SonarQube quality gate passed.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}"
            } else {
              emailext subject: "✅ Stage Passed: Quality Gate - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "SonarQube quality gate passed.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}", recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            }
          }
        }
        failure {
          script {
            if (env.EMAIL_RECIPIENTS?.trim()) {
              emailext to: "${env.EMAIL_RECIPIENTS}", subject: "❌ Stage Failed: Quality Gate - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "SonarQube quality gate failed. Code quality issues detected.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}"
            } else {
              emailext subject: "❌ Stage Failed: Quality Gate - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "SonarQube quality gate failed. Code quality issues detected.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}", recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            }
          }
        }
      }
    }

    stage('Docker Build') {
      steps {
        script {
          def imageTag = "${env.BUILD_NUMBER}"
          def commit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
          def fullTag = "${env.DOCKERHUB_NAMESPACE ?: 'your-dockerhub-namespace'}/cicd-pipeline:${imageTag}-${commit}"
          sh "docker build -t ${fullTag} ."
          env.IMAGE_NAME = fullTag
        }
      }
      post {
        success {
          script {
            if (env.EMAIL_RECIPIENTS?.trim()) {
              emailext to: "${env.EMAIL_RECIPIENTS}", subject: "✅ Stage Passed: Docker Build - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Docker image built successfully.\n\nImage: ${env.IMAGE_NAME}\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}"
            } else {
              emailext subject: "✅ Stage Passed: Docker Build - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Docker image built successfully.\n\nImage: ${env.IMAGE_NAME}\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}", recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            }
          }
        }
        failure {
          script {
            if (env.EMAIL_RECIPIENTS?.trim()) {
              emailext to: "${env.EMAIL_RECIPIENTS}", subject: "❌ Stage Failed: Docker Build - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Docker build failed. Please check the console output.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}"
            } else {
              emailext subject: "❌ Stage Failed: Docker Build - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Docker build failed. Please check the console output.\n\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}", recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            }
          }
        }
      }
    }

    stage('Trivy Scan') {
      steps {
        script {
          sh "docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:latest image --exit-code 1 --severity HIGH,CRITICAL ${env.IMAGE_NAME}"
        }
      }
      post {
        success {
          script {
            if (env.EMAIL_RECIPIENTS?.trim()) {
              emailext to: "${env.EMAIL_RECIPIENTS}", subject: "✅ Stage Passed: Trivy Security Scan - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Trivy security scan completed. No HIGH/CRITICAL vulnerabilities found.\n\nImage: ${env.IMAGE_NAME}\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}"
            } else {
              emailext subject: "✅ Stage Passed: Trivy Security Scan - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Trivy security scan completed. No HIGH/CRITICAL vulnerabilities found.\n\nImage: ${env.IMAGE_NAME}\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}", recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            }
          }
        }
        failure {
          script {
            if (env.EMAIL_RECIPIENTS?.trim()) {
              emailext to: "${env.EMAIL_RECIPIENTS}", subject: "❌ Stage Failed: Trivy Security Scan - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Trivy security scan found HIGH or CRITICAL vulnerabilities. Please review the image.\n\nImage: ${env.IMAGE_NAME}\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}"
            } else {
              emailext subject: "❌ Stage Failed: Trivy Security Scan - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Trivy security scan found HIGH or CRITICAL vulnerabilities. Please review the image.\n\nImage: ${env.IMAGE_NAME}\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}", recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            }
          }
        }
      }
    }

    stage('Push to DockerHub') {
      steps {
        withCredentials([usernamePassword(credentialsId: env.DOCKERHUB_CREDS, usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
          sh 'echo ${DOCKERHUB_PASS} | docker login -u ${DOCKERHUB_USER} --password-stdin'
          sh 'docker push ${IMAGE_NAME}'
          sh 'docker logout'
        }
      }
      post {
        success {
          script {
            if (env.EMAIL_RECIPIENTS?.trim()) {
              emailext to: "${env.EMAIL_RECIPIENTS}", subject: "✅ Stage Passed: Push to DockerHub - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Docker image pushed to DockerHub successfully.\n\nImage: ${env.IMAGE_NAME}\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}"
            } else {
              emailext subject: "✅ Stage Passed: Push to DockerHub - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Docker image pushed to DockerHub successfully.\n\nImage: ${env.IMAGE_NAME}\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}", recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            }
          }
        }
        failure {
          script {
            if (env.EMAIL_RECIPIENTS?.trim()) {
              emailext to: "${env.EMAIL_RECIPIENTS}", subject: "❌ Stage Failed: Push to DockerHub - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Failed to push Docker image to DockerHub. Please check credentials and console output.\n\nImage: ${env.IMAGE_NAME}\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}"
            } else {
              emailext subject: "❌ Stage Failed: Push to DockerHub - ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Failed to push Docker image to DockerHub. Please check credentials and console output.\n\nImage: ${env.IMAGE_NAME}\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}", recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            }
          }
        }
      }
    }

    stage('Send Test Email (explicit)') {
      steps {
        script {
          emailext(
            to: 'jayapramodmanikantan@gmail.com',
            subject: "Pipeline Notification: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body: "Stage completed. Job: ${env.JOB_NAME} #${env.BUILD_NUMBER}\nPlease check the build logs for details."
          )
        }
      }
      post {
        failure {
          echo 'Explicit test email failed (see Jenkins mailer logs).' 
        }
      }
    }
  }

  post {
    success {
      script {
        emailext subject: "Build Success: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "Build succeeded. Job: ${env.JOB_NAME} #${env.BUILD_NUMBER}\nImage: ${env.IMAGE_NAME}",
                 recipientProviders: [[$class: 'DevelopersRecipientProvider']]
      }
    }
    failure {
      script {
        emailext subject: "Build FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "Build failed. Job: ${env.JOB_NAME} #${env.BUILD_NUMBER}\nPlease check the console output.",
                 recipientProviders: [[$class: 'DevelopersRecipientProvider']]
      }
    }
  }
}
