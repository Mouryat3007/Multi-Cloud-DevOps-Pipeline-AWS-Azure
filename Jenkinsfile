pipeline {
  agent any

  environment {
    AWS_REGION = 'us-east-1'
    ECR_ACCOUNT_ID = credentials('aws-account-id')
    AZURE_CREDENTIALS = credentials('azure-service-principal')
    DOCKER_USERNAME = credentials('docker-username')
    DOCKER_PASSWORD = credentials('docker-password')
  }

  parameters {
    choice(name: 'TARGET_CLOUD', choices: ['aws', 'azure'], description: 'Choose cloud provider')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Provision Infrastructure') {
      steps {
        script {
          if (params.TARGET_CLOUD == 'aws') {
            sh './terraform/aws/init-and-apply.sh'
            sh 'aws eks update-kubeconfig --region us-east-1 --name my-eks-cluster'
          } else {
            sh './terraform/azure/init-and-apply.sh'
            sh 'az aks get-credentials --resource-group myResourceGroup --name my-aks-cluster'
          }
        }
      }
    }

    stage('Build & Push Docker Images') {
      steps {
        script {
          if (params.TARGET_CLOUD == 'aws') {
            sh './scripts/build-and-push-ecr.sh'
          } else {
            sh './scripts/build-and-push-acr.sh'
          }
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        script {
          sh "./scripts/deploy-k8s.sh ${params.TARGET_CLOUD}"
        }
      }
    }
  }

  post {
    success {
      echo '✅ Pipeline completed successfully!'
    }
    failure {
      echo '❌ Pipeline failed! Please check the logs.'
    }
  }
}
