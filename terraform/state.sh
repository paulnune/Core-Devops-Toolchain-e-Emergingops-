#!/bin/bash

# aws Common Services

# AWS Credential

export AWS_ACCESS_KEY_ID="SECRET"
export AWS_SECRET_ACCESS_KEY="SECRET/5TI726+6NP9yp/pvR/WTs0zVvB"
export AWS_SESSION_TOKEN="SECRET//////////SECRET+SECRET+SECRET/SECRET/SECRET/5UBLcqr+k0FRxDsOxQJokD+429uWTIgfCEOcmnUaP+UhM/XlRHrDgO2Qr46S/SECRET="
export AWS_REGION=us-east-1
export TFSTATE_NAME=paulonunes12dvptfstate001

# AWS Auth

curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt install -y terraform
apt install -y awscli
aws configure set aws_access_key_id $AWS_GOBAAS_COMMON_SERVICES_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_GOBAAS_COMMON_SECRET_ACCESS_KEY
aws configure set region $AWS_REGION

# Create an S3 bucket

aws s3api create-bucket \
--bucket $TFSTATE_NAME \
--region $AWS_REGION

aws s3api put-bucket-encryption \
--bucket $TFSTATE_NAME \
--server-side-encryption-configuration "{\"Rules\": [{\"ApplyServerSideEncryptionByDefault\":{\"SSEAlgorithm\": \"AES256\"}}]}"

# Create a DynamoDB Table

aws dynamodb create-table \
--table-name $TFSTATE_NAME \
--attribute-definitions AttributeName=LockID,AttributeType=S \
--key-schema AttributeName=LockID,KeyType=HASH \
--provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

