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
sudo docker pull smily75/rating-application


echo "Start docker container"
# on port 80
sudo docker run -d --rm --name web-test -p 80:8000 crccheck/hello-world
# on port 8080
docker run -d -p 8080:8080 ninrod/springboot:test java -jar /home/ninrod/delivery/ninrod-spring-boot-test-0.1.2.3.jar