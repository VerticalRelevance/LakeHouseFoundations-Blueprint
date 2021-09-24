#!/bin/bash

# Set Variables
. ../../scripts/set-variables.sh

# S3 Buckets
CompId="lh-s3"
aws cloudformation deploy \
    --stack-name "dev-lakehouse-$CompId" \
    --template-file "../infra/cf-lakehouse-s3.yml" \
    --parameter-overrides "ComponentID=$CompId" "Env=$Env" "Region=$Region" \
    --capabilities CAPABILITY_NAMED_IAM

# Glue Job Scripts to S3
aws s3 sync "../scripts"  $ResourceBucketURI

CompId="lh-glue"
aws cloudformation deploy \
    --stack-name "dev-lakehouse-$CompId" \
    --template-file "../infra/cf-lakehouse-glue.yml" \
    --parameter-overrides "ComponentID=$CompId"  "Env=$Env" "Region=$Region" \
    --capabilities CAPABILITY_NAMED_IAM 

