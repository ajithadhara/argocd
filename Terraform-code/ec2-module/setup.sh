#!/bin/bash

# Update and install prerequisites
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y wget curl gnupg2 software-properties-common apt-transport-https ca-certificates gnupg lsb-release

# Install Java (Jenkins + SonarQube require Java 17)
sudo apt-get install -y openjdk-17-jdk

# Install Jenkins
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.gpg] https://pkg.jenkins.io/debian binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y jenkins

sudo systemctl enable jenkins
sudo systemctl start jenkins

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Add 'ubuntu' user to the docker group
sudo usermod -aG docker ubuntu

# Install Trivy (version 0.62.1)
wget https://github.com/aquasecurity/trivy/releases/download/v0.62.1/trivy_0.62.1_Linux-64bit.deb
sudo dpkg -i trivy_0.62.1_Linux-64bit.deb


# Run SonarQube in Docker
docker run -d --name sonarqube -p 9000:9000 sonarqube:community
docker update --restart unless-stopped sonarqube
