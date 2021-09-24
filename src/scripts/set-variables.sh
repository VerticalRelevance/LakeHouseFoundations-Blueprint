#!/bin/bash

# Get shorthand account label. ie. lz=>landing-zone, lh=>lake-house-account (this comes from calling account deploy.sh scripts.)
export AccountShorthand="$1"

# Sets variables common to all the CI/CD scripts.
export Env=dev
export DeploymentRootName="lakehouse"
export Region=$(aws configure get region)
export AccountId=$(aws sts get-caller-identity --query Account --output text)
export ResourceBucketName="$Env-$DeploymentRootName-$AccountShorthand-s3-resources-$AccountId-$Region"
export ResourceBucketURI="s3://$ResourceBucketName"

echo "Env: $Env, Region: $Region, AccountId: $AccountId, ResourceBucketName: $ResourceBucketName, ResourceBucketURI: $ResourceBucketURI"
# printenv
