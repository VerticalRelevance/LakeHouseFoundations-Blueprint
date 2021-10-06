#!/bin/bash

# Require 2 arguments
set -o nounset
# Test IAM user passwords
TestUserPassword="$1"

. ./set-local-variables.sh

echo "Deploying Lake Formation stack.."
CompId="$AccountShorthand-lf"
aws cloudformation deploy \
    --stack-name $LfStackName \
    --template-file $LfStackPath \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "CompId=$CompId" "Env=$Env" "Region=$Region" \
        "TestUserPassword=$TestUserPassword"
