#!/bin/bash

. ./set-local-variables.sh

echo "Deleting Glue stack.."
CompId="$AccountShorthand-glue"
aws cloudformation delete-stack --stack-name $GlueStackName --output json
aws cloudformation wait stack-delete-complete --stack-name $GlueStackName --output json --no-paginate 
echo "Glue stack deleted."

# Delete bucket objects. {Curlys catch any error} || { echo "Error...not gonna kill your script"}
CompId="$AccountShorthand-s3"
{
    echo "Deleting S3 logging bucket objects.."
    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-logs-$AccountId-$Region" --recursive
    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-tmp-$AccountId-$Region" --recursive
    aws s3 rm $ResourceBucketURI --recursive

    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-raw-$AccountId-$Region" --recursive
    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-transformed-$AccountId-$Region" --recursive
    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-curated-$AccountId-$Region" --recursive
} || {
    echo "Error deleting bucket objects. It is likely already deleted. Check."
}

echo "Deleting S3 stack.."
aws cloudformation delete-stack --stack-name $S3StackName
aws cloudformation wait stack-delete-complete --stack-name $S3StackName --output json --no-paginate 
echo "S3 stack deleted."