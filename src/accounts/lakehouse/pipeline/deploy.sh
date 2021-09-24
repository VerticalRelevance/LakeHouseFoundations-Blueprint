#!/bin/bash

# Set Variables
. ../../scripts/set-variables.sh "lh"
S3StackPath="../infra/cf-$DeploymentRootName-s3.yml"
GlueStackPath="../infra/cf-$DeploymentRootName-glue.yml"

echo "Deploying S3 stack.."
CompId="lh-s3"
aws cloudformation deploy \
    --stack-name "$Env-$DeploymentRootName-$CompId" \
    --template-file $S3StackPath \
    --parameter-overrides "ComponentID=$CompId" "Env=$Env" "Region=$Region" \
    --capabilities CAPABILITY_NAMED_IAM

echo "Syncing resource files to S3 resource bucket.."
aws s3 sync "../scripts"  $ResourceBucketURI
echo "Resource files synced to S3 resource bucket."

echo "Deploying Glue stack.."
CompId="lh-glue"
aws cloudformation deploy \
    --stack-name "$Env-$DeploymentRootName-$CompId" \
    --template-file $GlueStackPath \
    --parameter-overrides "ComponentID=$CompId"  "Env=$Env" "Region=$Region" \
    --capabilities CAPABILITY_NAMED_IAM

