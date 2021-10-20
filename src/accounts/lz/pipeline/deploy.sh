#!/bin/bash

. ./set-local-variables.sh

# Require 1 argument
set -o nounset

# PostgreSQL admin password
PostgresqlPassword="$1"

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
        "WorkfowInitiatorFileName=$WorkflowInitiatorFileName" 

echo "Deploying RDS Postgres.."
# ! Do not create key pair here. This is for the reference architecture automation. Replace KeyPairName with name of predefined key pair.
KeyPairName="$Env-$DeploymentRootName-$CompId-postgres-bastion-keypair"
aws ec2 create-key-pair --key-name "$KeyPairName"
CompId="$AccountShorthand-rds"
aws cloudformation deploy \
    --stack-name $RdsStackName \
    --template-file $RdsStackPath \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "CompId=$CompId" "Env=$Env" "Region=$Region" \
        "pDBUsername=admin" \
        "pDBPassword=$PostgresqlPassword" \
        "ResourceBucketName=$ResourceBucketName" \
        "pBastionHostEC2KeyPair=$KeyPairName"
