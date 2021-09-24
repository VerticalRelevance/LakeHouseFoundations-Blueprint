#!/bin/bash

echo "Begin setting variables.."
. ../../../scripts/set-variables.sh "lz"

S3StackName="cf-$DeploymentRootName-$AccountShortHand-s3"
S3StackPath="../infra/cf-$AccountShortHand-s3.yml"

GlueStackName="cf-$DeploymentRootName-$AccountShortHand-glue"
GlueStackPath="../infra/cf-$AccountShortHand-glue.yml"
echo "End setting variables."

echo "Deploying S3 stack.."
CompId="lz-s3"
aws cloudformation deploy \
    --stack-name $S3StackName \
    --template-file $S3StackPath \
    --parameter-overrides "ComponentID=$CompId" "Env=$Env" "Region=$Region" \
    --capabilities CAPABILITY_NAMED_IAM

echo "Syncing resource files to S3 resource bucket.."
aws s3 sync "../scripts" "$ResourceBucketURI/$ComponentID"
echo "Resource files synced to S3 resource bucket."

echo "Deploying Glue stack.."
CompId="lh-glue"
aws cloudformation deploy \
    --stack-name $GlueStackName \
    --template-file $GlueStackPath \
    --parameter-overrides "ComponentID=$CompId"  "Env=$Env" "Region=$Region" \
    --capabilities CAPABILITY_NAMED_IAM
