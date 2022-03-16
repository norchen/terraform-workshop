#!/bin/bash

# echo "Update & Upgrade"
# sudo yum update -y
# sudo yum upgrade -y

echo "Enable Session Manager"
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

echo "Install docker"
sudo amazon-linux-extras install docker -y
sudo service docker start

# echo "Add ec2-user to docker group"
# sudo usermod -a -G docker ec2-user

echo "Get docker image"
# https://hub.docker.com/r/crccheck/hello-world
sudo docker pull smily75/rating-application:1.0.2


echo "Start docker container"
# on port 80
sudo docker run -d -e SPRING_PROFILES_ACTIVE=production -e JAVA_TOOL_OPTIONS=-Xmx64m --name rating-application -p 80:8080 smily75/rating-application:1.0.2
