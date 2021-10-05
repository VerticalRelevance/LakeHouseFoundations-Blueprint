#!/bin/bash

. ./set-local-variables.sh

echo "Deleting Lake Formation stack.."
CompId="$AccountShorthand-lf"
# Delete bucket objects. {<Curlys catch any error>} || { echo "Error...not gonna kill your script"}
{
    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-logs-$AccountId-$Region" --recursive
    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-lf-bucket-$AccountId-$Region" --recursive
} || {
    echo "Error deleting resource bucket objects. It is likely already deleted. Check."
}
aws cloudformation delete-stack --stack-name $LfStackName --output json
aws cloudformation wait stack-delete-complete --stack-name $LfStackName --output json --no-paginate 
echo "Lake Formation stack deleted."

