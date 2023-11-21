#!/bin/bash
# Getting AWS credentials from the terminal
echo "Please provide your AWS Access Key:"
read AWS_ACCESS_KEY
echo


echo "Please provide your AWS Secret Access Key:"
read AWS_SECRET_ACCESS_KEY
echo

echo "Please provide your AWS Session Token:"
read AWS_SESSION_TOKEN
echo

# Exporting the credentials to be accessible in all the scripts
echo "export AWS_ACCESS_KEY='$AWS_ACCESS_KEY'" > env_vars.sh
echo "export AWS_SECRET_ACCESS_KEY='$AWS_SECRET_ACCESS_KEY'" >> env_vars.sh
echo "export AWS_SESSION_TOKEN='$AWS_SESSION_TOKEN'" >> env_vars.sh

echo -e "Starting our Tool Assignment...\n"
echo -e "-----------\n"


# Deploying the infrastructure
echo -e "Deploying the infrastructure...\n"
./create_instances.sh
