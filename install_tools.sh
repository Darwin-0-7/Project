#!/bin/bash
# Update system packages
sudo apt-get update -y

# --- INSTALL DOCKER ---
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y
sudo apt-get update -y
sudo apt-get install -y docker-ce
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu

# --- INSTALL JAVA (Required for Jenkins) ---
sudo apt install -y fontconfig openjdk-17-jre

# --- INSTALL JENKINS ---
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Add Jenkins user to Docker group so Jenkins can build containers
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
