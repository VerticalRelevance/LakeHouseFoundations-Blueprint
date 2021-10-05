#!/bin/bash

# Require 2 arguments
set -o nounset
# Test IAM user passwords
TestUserPassword=$1

. ./set-local-variables.sh

CompId="$AccountShorthand-lf"
aws cloudformation deploy \
    --stack-name $LfStackName \
    --template-file $LfStackPath \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "CompId=$CompId" "Env=$Env" "Region=$Region" "TestUserPassword=$TestUserPassword"

CompId="$AccountShorthand-athena"
aws cloudformation deploy \
    --stack-name $AthenaStackName \
    --template-file $AthenaStackPath \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "CompId=$CompId" "Env=$Env"

KeyPairName="$Env-$DeploymentRootName-$CompID-redshift-bastion-keypair"
aws ec2 create-key-pair --key-name "$KeyPairName"
CompId="$AccountShorthand-redshift"
aws cloudformation deploy \
    --stack-name $SpectrumStackName \
    --template-file $SpectrumStackPath \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "CompId=$CompId" "Env=$Env" \
        "pAvailabilityZone=$pAvailabilityZone" \
        "pBastionHostEC2KeyPair=$KeyPairName"
