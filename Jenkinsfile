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
                        // Added the -e flag to inject the WEATHER_API_KEY into the container
                        bat """
                        icacls "%SSH_KEY%" /inheritance:r /grant SYSTEM:F
                        ssh -i "%SSH_KEY%" -o StrictHostKeyChecking=no ubuntu@13.201.34.110 "sudo docker pull ${DOCKER_HUB_USER}/${APP_NAME}:latest ; sudo docker stop weather-app ; sudo docker rm weather-app ; sudo docker run -d --name weather-app -p 5000:5000 -e WEATHER_API_KEY='6854f09a4c28f0eafbb8493321eaf6e3' ${DOCKER_HUB_USER}/${APP_NAME}:latest"
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
