#!/bin/bash

Env=dev
Region=$(aws configure get region)
AccountId=$(aws sts get-caller-identity --query Account --output text)

# Tear down all components
aws cloudformation delete-stack --stack-name "dev-lakehouse-lz-glue"

aws s3 rm s3://dev-lakehouse-lz-s3-resources-$AccountId-$Region --recursive
aws cloudformation delete-stack --stack-name "dev-lakehouse-lz-s3"
# aws cloudformation delete-stack --stack-name "dev-lakehouse-lz-msk"

# aws cloudformation delete-stack --stack-name "dev-lakehouse-lz-datasync"