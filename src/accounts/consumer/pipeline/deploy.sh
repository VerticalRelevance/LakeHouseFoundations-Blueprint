#!/bin/bash

# Require 1 arguments
set -o nounset
# Test IAM user passwords
TestUserPassword="$1"
# Redshift Availability Zone
pAvailabilityZone="$2"

. ./set-local-variables.sh

echo "Deploying Lake Formation stack.."
CompId="$AccountShorthand-lf"
aws cloudformation deploy \
    --stack-name $LfStackName \
    --template-file $LfStackPath \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "CompId=$CompId" "Env=$Env" "Region=$Region" "TestUserPassword=$TestUserPassword"

echo "Deploying Athena stack.."
CompId="$AccountShorthand-athena"
aws cloudformation deploy \
    --stack-name $AthenaStackName \
    --template-file $AthenaStackPath \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "CompId=$CompId" "Env=$Env"

echo "Deploying Redshift stack.."
# ! Do not create key pair here. This is for the reference architecture automation. Replace KeyPairName with name of predefined key pair.
KeyPairName="$Env-$DeploymentRootName-$CompId-redshift-bastion-keypair"
aws ec2 create-key-pair --key-name "$KeyPairName"
CompId="$AccountShorthand-redshift"
aws cloudformation deploy \
    --stack-name $SpectrumStackName \
    --template-file $SpectrumStackPath \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "CompId=$CompId" "Env=$Env" \
        "pAvailabilityZone=$pAvailabilityZone" \
        "pBastionHostEC2KeyPair=$KeyPairName"
    