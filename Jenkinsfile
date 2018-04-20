pipeline {
    agent {
        node {
            label 'master'
        }
    }

    stages {

        stage('terraform started') {
            steps {
                sh 'echo "Started...!" '
            }
        }
        
       
        stage('terraform initialization stage') {
            steps {
                sh 'terraform init'
            }
        }
        stage('terraform planning stage') {
            steps {
                sh 'terraform plan'
            }
        }
        stage('terraform applying stage') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
        stage('terraform ended') {
            steps {
                sh 'echo "Ended....!!"'
            }
        }

        
    }
}
