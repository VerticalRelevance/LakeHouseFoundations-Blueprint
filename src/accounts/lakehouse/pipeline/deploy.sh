#!/bin/bash

# aws s3 sync ../ s3://lakehouse-deployment-resources-15362389/accounts/lakehouse/infra/* --delete --exclude "*" --include "*.yml"

# Deploy

aws cloudformation deploy \
    --stack-name "dev-lakehouse-lh-s3" \
    --template-file "../infra/cf-lakehouse-s3.yml" \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "ComponentID=lh-s3" "Env=dev"

# Run integration tests for deployment
