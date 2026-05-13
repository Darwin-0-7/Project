pipeline {
    agent any

    environment {
        // Your specific Docker Hub and project details
        DOCKER_HUB_USER = 'darwin0407'
        APP_NAME = 'weather-tracker'
        IMAGE_TAG = "${env.BUILD_NUMBER}" 
        DOCKER_CREDENTIALS_ID = 'Darwincr7' 
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Pulls the latest code from your GitHub repository
                git branch: 'main', url: 'https://github.com/Darwin-0-7/Project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Builds the Docker image locally on your laptop using 'bat' for Windows
                    bat "docker build -t ${DOCKER_HUB_USER}/${APP_NAME}:${IMAGE_TAG} ."
                    bat "docker tag ${DOCKER_HUB_USER}/${APP_NAME}:${IMAGE_TAG} ${DOCKER_HUB_USER}/${APP_NAME}:latest"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // Uses your Jenkins vault credentials to push the image to Docker Hub
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
                    // Temporarily loads your AWS private key
                    withCredentials([sshUserPrivateKey(credentialsId: 'aws-ec2-key', keyFileVariable: 'SSH_KEY')]) {
                        // 1. Explicitly grants permission to the SYSTEM account running Jenkins
                        // 2. ssh logs into AWS, pulls the new image, and restarts the container
                        bat """
                        icacls "%SSH_KEY%" /inheritance:r /grant SYSTEM:F
                        ssh -i "%SSH_KEY%" -o StrictHostKeyChecking=no ubuntu@13.233.10.185 "sudo docker pull ${DOCKER_HUB_USER}/${APP_NAME}:latest && sudo docker stop weather-app  true && sudo docker rm weather-app  true && sudo docker run -d --name weather-app -p 5000:5000 ${DOCKER_HUB_USER}/${APP_NAME}:latest"
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
