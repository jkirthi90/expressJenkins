pipeline {
    agent any

    stages {
        stage('Install') {
            steps {
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test'
            }
        }

        stage('Deploy to Staging') {
            when {
                branch 'staging'
            }
            steps {
                echo 'Deploying to staging server...'
                sh 'pm2 restart app || pm2 start testingapp.js --name app'
            }
        }

        stage('Build Docker Image') {
            when {
                branch 'main'
            }
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t kirthij90/express-app:latest .'
            }
        }

        stage('Push to DockerHub') {
            when {
                branch ‘master’
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push kirthij90/express-app:latest'
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline passed on branch: ${env.BRANCH_NAME}"
        }
        failure {
            echo "❌ Pipeline failed on branch: ${env.BRANCH_NAME}"
        }
    }
}
