#!/bin/bash
# Build the Docker image
docker build -f app/Dockerfile -t server_app ./app

# Tag the Docker image
docker tag server_app mingxiaoyuan/log6307e_server_app:latest

# Push the Docker image to the repository
docker push mingxiaoyuan/log6307e_server_app:latest
