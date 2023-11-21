#!/bin/bash

# Access the env variables
source env_vars.sh

echo -e "Creating instances...\n"

# Initialize Terraform
terraform.exe init

# Applies the the main.tf
terraform.exe apply -auto-approve -var="aws_access_key_id=$AWS_ACCESS_KEY" -var="aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" -var="aws_session_token=$AWS_SESSION_TOKEN"

# Retrieve the load balancer URL
load_balancer_url=$(terraform.exe output --raw load_balancer_url)

echo -e "Everything was created successfully\n"
echo -e "-----------\n"