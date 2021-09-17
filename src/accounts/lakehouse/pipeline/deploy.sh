#!/bin/bash

# aws s3 sync ../ s3://lakehouse-deployment-resources-15362389/accounts/lakehouse/infra/* --delete --exclude "*" --include "*.yml"

# Deploy

# S3 Buckets
aws cloudformation deploy \
    --stack-name "dev-lakehouse-lh-s3" \
    --template-file "../infra/cf-lakehouse-s3.yml" \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "ComponentID=lh-s3" "Env=dev"

# Glue Job Scripts to S3
aws s3 sync "../scripts" "s3://dev-lakehouse-lh-s3-glue-resources/scripts_lh"

aws cloudformation deploy \
    --stack-name "dev-lakehouse-lh-glue" \
    --template-file "../infra/cf-lakehouse-glue.yml" \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "ComponentID=lh-glue2" "Env=dev"

# Run integration tests for deployment
