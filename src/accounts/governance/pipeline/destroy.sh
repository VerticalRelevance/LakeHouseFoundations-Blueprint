#!/bin/bash

echo "Begin setting variables.."
. ../../../scripts/set-variables.sh "gov"

LfStackName="$Env-$DeploymentRootName-$AccountShorthand-lf"
LfStackPath="../infra/cf-$AccountShorthand-lakeformation.yml"
echo "End setting variables."

echo "Deleting Lake Formation stack.."
CompId="$AccountShorthand-lf"
# Delete bucket objects (Curlys catch any error)
{
    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-logs-$AccountId-$Region" --recursive
    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-lf-bucket-$AccountId-$Region" --recursive
} || {
    echo "Error deleting resource bucket objects. It is likely already deleted. Check."
}
aws cloudformation delete-stack --stack-name $LfStackName --output json
aws cloudformation wait stack-delete-complete --stack-name $LfStackName --output json --no-paginate 
echo "Lake Formation stack deleted."

