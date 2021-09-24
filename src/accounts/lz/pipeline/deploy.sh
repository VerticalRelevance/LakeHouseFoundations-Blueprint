#!/bin/bash

# Set Variables
. ../../../scripts/set-variables.sh

echo "Deploying S3 stack.."
aws cloudformation deploy \
    --stack-name "dev-lakehouse-lz-s3" \
    --template-file "../infra/cf-lz-s3.yml" \
    --parameter-overrides "ComponentID=lz-s3" "Env=$Env" "Region=$Region" \
    --capabilities CAPABILITY_NAMED_IAM

echo "Syncing resource files to S3 resource bucket.."
aws s3 sync "../scripts" "$ResourceBucketURI/$ComponentID"
echo "Resource files synced to S3 resource bucket."

echo "Deploying Glue stack.."
aws cloudformation deploy \
    --stack-name "dev-lakehouse-lz-glue" \
    --template-file "../infra/cf-lz-glue.yml" \
    --parameter-overrides "ComponentID=lz-glue" "Env=$Env" "Region=$Region" \
    --capabilities CAPABILITY_NAMED_IAM
