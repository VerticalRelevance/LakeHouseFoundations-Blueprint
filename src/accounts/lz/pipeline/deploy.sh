#!/bin/bash


# aws s3 sync ../ s3://lakehouse-deployment-resources-15362389/accounts/consumer/infra/* \
# --delete --exclude "*" \
# --include "*.yml"


Env=dev
Region=$(aws configure get region)
AccountId=$(aws sts get-caller-identity --query Account --output text)
ResourceBucketURI="s3://$Env-lakehouse-lz-s3-resources-$AccountId-$Region/scripts_lz"

echo "Env: $Env, Region: $Region, AccountId: $AccountId, ResourceBucketURI: $ResourceBucketURI"

# Deploy
aws cloudformation deploy \
    --stack-name "dev-lakehouse-lz-s3" \
    --template-file "../infra/cf-lz-s3.yml" \
    --parameter-overrides "ComponentID=lz-s3" "Env=$Env" "Region=$Region" \
    --capabilities CAPABILITY_NAMED_IAM

# Glue Job Scripts to S3
aws s3 sync "../scripts" $ResourceBucketURI

aws cloudformation deploy \
    --stack-name "dev-lakehouse-lz-glue" \
    --template-file "../infra/cf-lz-glue.yml" \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "ComponentID=lz-glue" "Env=$Env" "Region=$Region"


# aws cloudformation deploy \
#     --stack-name "dev-lakehouse-lz-datasync" \
#     --template-file "../infra/cf-lz-datasync.yml" \
#     --capabilities CAPABILITY_NAMED_IAM \
#     --parameter-overrides "ComponentID=lz-datasync" "Env=dev"

# aws cloudformation deploy \
#     --stack-name "dev-lakehouse-lz-msk" \
#     --template-file "../infra/cf-lakehouse-msk.yml" \
#     --capabilities CAPABILITY_NAMED_IAM \
#     --parameter-overrides "ComponentID=consumer" "Env=dev"

# aws cloudformation create-stack \
#     --stack-name "dev-lakehouse-consumer" \
#     --template-body "file://../infra/cf-consumer-reshift-spectrum.yml" \
#     --capabilities CAPABILITY_NAMED_IAM

# Run integration tests for deployment
