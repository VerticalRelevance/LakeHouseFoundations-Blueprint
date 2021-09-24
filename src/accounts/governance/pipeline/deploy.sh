#!/bin/bash


TestUserPassword=$1

echo "Begin setting variables.."
. ../../../scripts/set-variables.sh "gov"

LfStackName="${Env}-$DeploymentRootName-$AccountShorthand-lf"
LfStackPath="../infra/cf-$AccountShorthand-lakeformation.yml"
echo "End setting variables."

echo "Deploying Lake Formation stack.."
CompId="$AccountShorthand-lf"
aws cloudformation deploy \
    --stack-name $LfStackName \
    --template-file $LfStackPath \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "ComponentID=$CompId" "Env=$Env" "Region=$Region" "TestUserPassword=$TestUserPassword"
