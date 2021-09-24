#!/bin/bash

# Get shorthand account label. ie. lz=>landing-zone, lh=>lake-house-account (this comes from calling account deploy.sh scripts.)
export AccountShortHand=$1

# Sets variables common to all the CI/CD scripts.
export DeploymentRootName="lakehouse"
export Env=dev
export Region=$(aws configure get region)
export AccountId=$(aws sts get-caller-identity --query Account --output text)
export ResourceBucketURI="s3://$Env-$DeploymentRootName-$AccountShortHand-s3-resources-$AccountId-$Region/scripts_$AccountShortHand"

echo "Env: $Env, Region: $Region, AccountId: $AccountId, ResourceBucketURI: $ResourceBucketURI"
