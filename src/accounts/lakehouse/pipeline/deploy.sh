#!/bin/bash


# Require 1 argument
set -o nounset
# Redshift Availability Zone
pAvailabilityZone=$2

echo "Begin setting variables.."
. ../../../scripts/set-variables.sh "lh"

S3StackName="${Env}-$DeploymentRootName-$AccountShorthand-s3"
S3StackPath="../infra/cf-$AccountShorthand-s3.yml"

GlueStackName="${Env}-$DeploymentRootName-$AccountShorthand-glue"
GlueStackPath="../infra/cf-$AccountShorthand-glue.yml"

RedshiftStackName="${Env}-$DeploymentRootName-$AccountShorthand-redshift"
RedshiftStackPath="../infra/cf-$AccountShorthand-redshift.yml"
echo "End setting variables."

echo "Deploying S3 stack.."
CompId="$AccountShorthand-s3"
aws cloudformation deploy \
    --stack-name $S3StackName \
    --template-file $S3StackPath \
    --parameter-overrides "ComponentID=$CompId" "Env=$Env" "Region=$Region" "ResourceBucketName=$ResourceBucketName"\
    --capabilities CAPABILITY_NAMED_IAM

echo "Syncing resource files to S3 resource bucket.."
aws s3 sync "../scripts" "$ResourceBucketURI/$AccountShorthand-scripts"
echo "Resource files synced to S3 resource bucket."

echo "Deploying Glue stack.."
CompId="$AccountShorthand-glue"
aws cloudformation deploy \
    --stack-name $GlueStackName \
    --template-file $GlueStackPath \
    --parameter-overrides "ComponentID=$CompId"  "Env=$Env" "Region=$Region" \
    --capabilities CAPABILITY_NAMED_IAM

CompId="$AccountShorthand-redshift"
aws cloudformation deploy \
    --stack-name $SpectrumStackName \
    --template-file $SpectrumStackPath \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "ComponentID=$CompId" "Env=$Env" \
        "pAvailabilityZone=$pAvailabilityZone" \
        "pBastionHostEC2KeyPair=dev-lakehouse-cons1-redshift-bastion-keypair"