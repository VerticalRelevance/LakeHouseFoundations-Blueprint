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

CompId="$AccountShorthand-cons1"
aws cloudformation deploy \
    --stack-name $LfStackName \
    --template-file $LfStackPath \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "ComponentID=$CompId" "Env=$Env" "Region=$Region" "TestUserPassword=$TestUserPassword"

aws cloudformation deploy \
    --stack-name "dev-lakehouse-consumer-redshiftspectrum" \
    --template-file "../infra/cf-consumer-redshift-spectrum.yml" \
    --parameter-overrides "ComponentID=consumer-catalog" "Env=dev" \
    --capabilities CAPABILITY_NAMED_IAM

# Run integration tests for deployment
