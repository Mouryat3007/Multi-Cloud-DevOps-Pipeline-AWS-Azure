pipeline {
  agent any

  environment {
    AWS_DEFAULT_REGION = 'us-east-1'  // Set your AWS region here or pass as param
  }

  parameters {
    choice(name: 'TARGET_CLOUD', choices: ['aws', 'azure'], description: 'Choose cloud provider')
  }

  stages {
    stage('Clean Workspace') {
      steps {
        cleanWs() // Clean the workspace to avoid caching old Terraform state or modules
      }
    }

    stage('Checkout SCM') {
      steps {
        checkout scm
      }
    }

    stage('Provision Infrastructure') {
      steps {
        script {
          if (params.TARGET_CLOUD == 'aws') {
            dir('terraform/aws') {
              sh '''
                terraform init -upgrade
                terraform plan -out=tfplan
                terraform apply -auto-approve tfplan
              '''
              sh 'aws eks update-kubeconfig --region $AWS_DEFAULT_REGION --name my-eks-cluster'
            }
          } else if (params.TARGET_CLOUD == 'azure') {
            dir('terraform/azure') {
              sh '''
                terraform init -upgrade
                terraform plan -out=tfplan
                terraform apply -auto-approve tfplan
              '''
              sh 'az aks get-credentials --resource-group myResourceGroup --name my-aks-cluster'
            }
          } else {
            error "Unsupported TARGET_CLOUD: ${params.TARGET_CLOUD}"
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
