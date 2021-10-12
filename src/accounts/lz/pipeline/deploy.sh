#!/bin/bash

. ./set-local-variables.sh

BuildTimestamp=$(date +%s)

echo "Deploying S3 stack.."
CompId="$AccountShorthand-s3"
aws cloudformation deploy \
    --stack-name $S3StackName \
    --template-file $S3StackPath \
    --parameter-overrides "CompId=$CompId" "Env=$Env" "Region=$Region" "ResourceBucketName=$ResourceBucketName" \
    --capabilities CAPABILITY_NAMED_IAM

echo "Syncing resource files to S3 resource bucket.."
aws s3 sync "../scripts" "$ResourceBucketURI/$AccountShorthand-scripts"
WorkflowInitiatorFileName="cf-$AccountShorthand-orch-glue-operator"
WorkflowInitiatorZipFileName="$WorkflowInitiatorFileName-$BuildTimestamp.zip"
rm -rf ./*.zip
zip a -r "$WorkflowInitiatorZipFileName" "../infra/*.py"
WorkflowInitiatorS3Location="$AccountShorthand-scripts/$WorkflowInitiatorZipFileName"
aws s3 cp "$WorkflowInitiatorZipFileName" "$ResourceBucketURI/$WorkflowInitiatorS3Location"
echo "Resource files synced to S3 resource bucket."

echo "Deploying Glue stack.."
CompId="$AccountShorthand-glue"
aws cloudformation deploy \
    --stack-name $GlueStackName \
    --template-file $GlueStackPath \
    --capabilities CAPABILITY_NAMED_IAM
    --parameter-overrides "CompId=$CompId" "Env=$Env" "Region=$Region" \
        "ResourceBucketName=$ResourceBucketName" \
        "WorkflowInitiatorS3Location=$WorkflowInitiatorS3Location" \
        "WorkfowInitiatorFileName=$WorkflowInitiatorFileName" \
