#!/bin/bash


# Require 1 argument
set -o nounset
# Redshift Availability Zone
pAvailabilityZone="$1"

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

echo "Deploying Redshift stack.."
# ! Do not create key pair here. This is for the reference architecture automation. Replace KeyPairName with name of predefined key pair.
KeyPairName="$Env-$DeploymentRootName-$CompId-redshift-bastion-keypair"
aws ec2 create-key-pair --key-name "$KeyPairName"
CompId="$AccountShorthand-redshift"
aws cloudformation deploy \
    --stack-name $RedshiftStackName \
    --template-file $RedshiftStackPath \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "CompId=$CompId" "Env=$Env" \
        "pAvailabilityZone=$pAvailabilityZone" \
        "pBastionHostEC2KeyPair=$KeyPairName"