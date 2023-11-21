#!/bin/bash
# Install necessary dependencies
sudo yum update -y
sudo yum install -y docker

# Add ec2-user to the docker group so you can execute Docker commands without using sudo
sudo usermod -a -G docker ec2-user

# Start Docker
sudo service docker start

# Pull the latest image flask_app image from Docker Hub
{
    echo "Starting Docker image pull at $(date)"
    docker pull mingxiaoyuan/worker:latest
    echo "Docker image pull completed at $(date)"
} &>> /var/log/docker_pull.log


# In the docker container, expose the ec2 instance id
export INSTANCE_ID_EC2=$(ec2-metadata --instance-id)

# Run the Flask app inside a Docker container
sudo docker run -e INSTANCE_ID_EC2="$INSTANCE_ID_EC2" -d -p 80:5000 mingxiaoyuan/log6307e_server_app:latest