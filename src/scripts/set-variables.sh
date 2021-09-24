#!/bin/bash


export Env=dev
export Region=$(aws configure get region)
export AccountId=$(aws sts get-caller-identity --query Account --output text)
export ResourceBucketURI="s3://$Env-lakehouse-lz-s3-resources-$AccountId-$Region/scripts_lz"

echo "Env: $Env, Region: $Region, AccountId: $AccountId, ResourceBucketURI: $ResourceBucketURI"
