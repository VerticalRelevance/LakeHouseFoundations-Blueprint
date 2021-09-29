#!/bin/bash

echo "Begin setting variables.."
. ../../../scripts/set-variables.sh "lz"

S3StackName="$Env-$DeploymentRootName-$AccountShorthand-s3"
S3StackPath="../infra/cf-$AccountShorthand-s3.yml"

GlueStackName="$Env-$DeploymentRootName-$AccountShorthand-glue"
GlueStackPath="../infra/cf-$AccountShorthand-glue.yml"
echo "End setting variables."

echo "Deleting Glue stack.."
CompId="$AccountShorthand-glue"
aws cloudformation delete-stack --stack-name $GlueStackName --output json
aws cloudformation wait stack-delete-complete --stack-name $GlueStackName --output json --no-paginate 
echo "Glue stack deleted."

# Delete bucket objects (Curlys catch any error)
CompId="$AccountShorthand-s3"
{
    aws s3 rm $ResourceBucketURI --recursive
    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-logs-$AccountId-$Region" --recursive
    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-glue-temp-$AccountId-$Region" --recursive

    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-lz-bucket-$AccountId-$Region" --recursive
    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-producer-bucket-$AccountId-$Region" --recursive
} || {
    echo "Error deleting resource bucket objects. It is likely already deleted. Check."
}

echo "Deleting S3 stack.."
aws cloudformation delete-stack --stack-name $S3StackName
aws cloudformation wait stack-delete-complete --stack-name $S3StackName --output json --no-paginate 
echo "S3 stack deleted."