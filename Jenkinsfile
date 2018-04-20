pipeline {
    agent {
        node {
            label 'master'
        }
    }

    stages {

        stage('Terraform Starting Stage') {
            steps {
                sh 'echo "Started...!" '
            }
        }
        
       
        stage('Terraform Initialization Stage') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Planning Stage') {
            steps {
                sh 'terraform plan'
            }
        }
        stage('Terraform Applying Stage') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
        stage('Terraform Ended') {
            steps {
                sh 'echo "Ended....!!"'
            }
        }

        
    }
}
