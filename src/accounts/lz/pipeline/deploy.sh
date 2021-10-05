#!/bin/bash

. ./set-local-variables.sh

echo "Deploying S3 stack.."
CompId="$AccountShorthand-s3"
aws cloudformation deploy \
    --stack-name $S3StackName \
    --template-file $S3StackPath \
    --parameter-overrides "CompId=$CompId" "Env=$Env" "Region=$Region" "ResourceBucketName=$ResourceBucketName"\
    --capabilities CAPABILITY_NAMED_IAM

echo "Syncing resource files to S3 resource bucket.."
aws s3 sync "../scripts" "$ResourceBucketURI/$AccountShorthand-scripts"
echo "Resource files synced to S3 resource bucket."

echo "Deploying Glue stack.."
CompId="$AccountShorthand-glue"
aws cloudformation deploy \
    --stack-name $GlueStackName \
    --template-file $GlueStackPath \
    --parameter-overrides "CompId=$CompId"  "Env=$Env" "Region=$Region" \
    --capabilities CAPABILITY_NAMED_IAM
