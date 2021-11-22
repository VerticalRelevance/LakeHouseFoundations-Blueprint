#!/bin/bash

. ./set-local-variables.sh

aws cloudformation describe-stack-set --stack-set-name $S3StackName
aws cloudformation describe-stack-set --stack-set-name $LfStackName