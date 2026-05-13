pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'darwin0407'
        APP_NAME = 'weather-tracker'
        IMAGE_TAG = "${env.BUILD_NUMBER}" 
        DOCKER_CREDENTIALS_ID = 'Darwincr7' 
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Darwin-0-7/Project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    bat "docker build -t ${DOCKER_HUB_USER}/${APP_NAME}:${IMAGE_TAG} ."
                    bat "docker tag ${DOCKER_HUB_USER}/${APP_NAME}:${IMAGE_TAG} ${DOCKER_HUB_USER}/${APP_NAME}:latest"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_CREDENTIALS_ID) {
                        bat "docker push ${DOCKER_HUB_USER}/${APP_NAME}:${IMAGE_TAG}"
                        bat "docker push ${DOCKER_HUB_USER}/${APP_NAME}:latest"
                    }
                }
            }
        }

        stage('Deploy to AWS EC2') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'aws-ec2-key', keyFileVariable: 'SSH_KEY')]) {
                        // 1. Lock the key file to the Jenkins SYSTEM account
                        // 2. Try to stop/remove old containers, but don't crash if they don't exist yet (|| exit 0)
                        // 3. Pull the fresh image and run it
                        bat """
                        icacls "%SSH_KEY%" /inheritance:r /grant SYSTEM:F
                        ssh -i "%SSH_KEY%" -o StrictHostKeyChecking=no ubuntu@13.233.10.185 "sudo docker stop weather-app ; sudo docker rm weather-app" || exit 0
                        ssh -i "%SSH_KEY%" -o StrictHostKeyChecking=no ubuntu@13.233.10.185 "sudo docker pull ${DOCKER_HUB_USER}/${APP_NAME}:latest && sudo docker run -d --name weather-app -p 5000:5000 ${DOCKER_HUB_USER}/${APP_NAME}:latest"
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "CI/CD Pipeline Complete! The new version is live on AWS."
        }
        failure {
            echo "Pipeline failed. Check the Console Output in Jenkins."
        }
    }
}
