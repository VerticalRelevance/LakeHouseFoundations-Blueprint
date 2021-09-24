#!/bin/bash


# aws s3 sync ../ s3://lakehouse-deployment-resources-15362389/accounts/consumer/infra/* \
# --delete --exclude "*" \
# --include "*.yml"

# Deploy

aws cloudformation deploy \
    --stack-name "dev-lakehouse-governance-lakeformation" \
    --template-file "../infra/cf-governance-lakeformation.yml" \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "ComponentID=gov-lf" "Env=dev"

# aws cloudformation deploy \
#     --stack-name "dev-lakehouse-governance-crawler" \
#     --template-file "../infra/cf-governance-crawler.yml" \
#     --capabilities CAPABILITY_NAMED_IAM \
#     --parameter-overrides "ComponentID=gov-crawler" "Env=dev"

# Run integration tests for deployment
