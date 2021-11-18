#!/bin/bash

. ./set-local-variables.sh

echo "Deleting Glue stack.."
CompId="$AccountShorthand-glue"
aws cloudformation delete-stack --stack-name $GlueStackName --output json
aws cloudformation wait stack-delete-complete --stack-name $GlueStackName --output json --no-paginate 
echo "Glue stack deleted."

echo "Deleting RDS stack.."
aws cloudformation delete-stack --stack-name $RdsStackName
aws cloudformation wait stack-delete-complete --stack-name $RdsStackName --output json --no-paginate
echo "RDS stack deleted."

echo "Deleting S3 stack.."
# Delete bucket objects. {<Curlys catch any error>} || { echo "Error...not gonna kill your script"}
CompId="$AccountShorthand-s3"
{
    aws s3 rm $ResourceBucketURI --recursive
    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-logs-$AccountId-$Region" --recursive
    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-glue-tmp-$AccountId-$Region" --recursive

    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-lz-bucket-$AccountId-$Region" --recursive
    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-producer-bucket-$AccountId-$Region" --recursive
} || {
    echo "Error deleting resource bucket objects. It is likely already deleted. Check."
}
aws cloudformation delete-stack --stack-name $S3StackName
aws cloudformation wait stack-delete-complete --stack-name $S3StackName --output json --no-paginate

echo "S3 stack deleted."
