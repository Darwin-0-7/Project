pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'darwin0407' // Your Docker Hub ID
        APP_NAME = 'weather-tracker'
        IMAGE_TAG = "${env.BUILD_NUMBER}" 
        DOCKER_CREDENTIALS_ID = 'Darwincr7' // The ID you created in Jenkins
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Pointing to your specific repository
                git branch: 'main', url: 'https://github.com/Darwin-0-7/Project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Using 'bat' for Windows-based Jenkins
                    bat "docker build -t ${DOCKER_HUB_USER}/${APP_NAME}:${IMAGE_TAG} ."
                    bat "docker tag ${DOCKER_HUB_USER}/${APP_NAME}:${IMAGE_TAG} ${DOCKER_HUB_USER}/${APP_NAME}:latest"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // Logs into Docker Hub using your Jenkins credentials
                    docker.withRegistry('', DOCKER_CREDENTIALS_ID) {
                        bat "docker push ${DOCKER_HUB_USER}/${APP_NAME}:${IMAGE_TAG}"
                        bat "docker push ${DOCKER_HUB_USER}/${APP_NAME}:latest"
                    }
                }
            }
        }
    }
       
        stage('Deploy to AWS EC2') {
            steps {
                script {
                    // This securely loads your AWS key
                    sshagent(['aws-ec2-key']) {
                        // Logs into AWS, stops the old container, pulls the new one, and runs it!
                        bat """
                        ssh -o StrictHostKeyChecking=no ubuntu@YOUR_EC2_IP "
                        sudo docker pull darwin0407/weather-tracker:latest && 
                        sudo docker stop weather-app || true && 
                        sudo docker rm weather-app || true && 
                        sudo docker run -d --name weather-app -p 5000:5000 darwin0407/weather-tracker:latest
                        "
                        """
                 }
             }
         }
     }
    
    post {
        success {
            echo "CI Pipeline Complete! Image version ${IMAGE_TAG} is now on Docker Hub."
        }
        failure {
            echo "Pipeline failed. Check the Console Output in Jenkins."
        }
    }
}
