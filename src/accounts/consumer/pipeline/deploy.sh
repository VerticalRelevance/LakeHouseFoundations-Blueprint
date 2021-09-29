#!/bin/bash

# Require 2 arguments
set -o nounset
# Test IAM user passwords
TestUserPassword=$(1?You must supply a password string as the first argument.)
# Redshift Availability Zone
pAvailabilityZone=$(2?You must specify the Redshift an availability zone as the second argument.)

echo "Begin setting variables.."
. ../../../scripts/set-variables.sh "cons"

LfStackName="${Env}-$DeploymentRootName-$AccountShorthand-lakeformation"
LfStackPath="../infra/cf-$AccountShorthand-lakeformation.yml"

AthenaStackName="${Env}-$DeploymentRootName-$AccountShorthand-athena"
AthenaStackPath="../infra/cf-$AccountShorthand-athena.yml"

SpectrumStackName="${Env}-$DeploymentRootName-$AccountShorthand-redshift-spectrum"
SpectrumStackPath="../infra/cf-$AccountShorthand-redshift-spectrum.yml"

echo "End setting variables."

CompId="$AccountShorthand-lf"
aws cloudformation deploy \
    --stack-name $LfStackName \
    --template-file $LfStackPath \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "ComponentID=$CompId" "Env=$Env" "Region=$Region" "TestUserPassword=$TestUserPassword"

CompId="$AccountShorthand-athena"
aws cloudformation deploy \
    --stack-name $AthenaStackName \
    --template-file $AthenaStackPath \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "ComponentID=$CompId" "Env=$Env"

CompId="$AccountShorthand-spectrum"
aws cloudformation deploy \
    --stack-name $SpectrumStackName \
    --template-file $SpectrumStackPath \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "ComponentID=$CompId" "Env=$Env" \
        "pAvailabilityZone=us-east-1a" \
        "pBastionHostEC2KeyPair=dev-lakehouse-cons1-redshift-bastion-keypair"

# Run integration tests for deployment
