#!/bin/bash


# aws s3 sync ../ s3://lakehouse-deployment-resources-15362389/accounts/consumer/infra/* \
# --delete --exclude "*" \
# --include "*.yml"

# Deploy
aws cloudformation deploy \
    --stack-name "dev-lakehouse-consumer-athena" \
    --template-file "../infra/cf-consumer-athena.yml" \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "ComponentID=consumer-athena" "Env=dev"

# aws cloudformation deploy \
#     --stack-name "dev-lakehouse-consumer-catalog" \
#     --template-file "../infra/cf-consumer-catalog.yml" \
#     --parameter-overrides "ComponentID=consumer-catalog" "Env=dev" \
#     --capabilities CAPABILITY_NAMED_IAM

# aws cloudformation deploy \
#     --stack-name "dev-lakehouse-consumer-lakeformation" \
#     --template-file "../infra/cf-consumer-lakeformation.yml" \
#     --capabilities CAPABILITY_NAMED_IAM \
#     --parameter-overrides "ComponentID=consumer" "Env=dev"

aws cloudformation deploy \
    --stack-name "dev-lakehouse-consumer-redshiftspectrum" \
    --template-file "../infra/cf-consumer-redshift-spectrum.yml" \
    --parameter-overrides "ComponentID=consumer-catalog" "Env=dev" \
    --capabilities CAPABILITY_NAMED_IAM

# Run integration tests for deployment
