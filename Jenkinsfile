pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "kirthij90/express-app"
        GIT_COMMIT_SHA = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
    }

    stages {
        stage('Install') {
            steps {
                sh 'npm install'
            }
        }

        stage('Lint') {
            steps {
                sh 'npx eslint testingapp.js'
            }
            post {
                failure {
                    echo '❌ Linting failed — fix code quality issues before proceeding'
                }
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
                branch 'master'
            }
            steps {
                echo "Building Docker image with tag: ${GIT_COMMIT_SHA}"
                sh "docker build -t ${DOCKER_IMAGE}:${GIT_COMMIT_SHA} -t ${DOCKER_IMAGE}:latest ."
            }
        }

        stage('Push to DockerHub') {
            when {
                branch 'master'
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${DOCKER_IMAGE}:${GIT_COMMIT_SHA}"
                    sh "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline passed on branch: ${env.BRANCH_NAME}"
            echo "✅ Image pushed: ${DOCKER_IMAGE}:${GIT_COMMIT_SHA}"
        }
        failure {
            echo "❌ Pipeline failed on branch: ${env.BRANCH_NAME}"
        }
        always {
            echo "🧹 Cleaning up workspace..."
            cleanWs()
        }
    }
}
