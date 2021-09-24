#!/bin/bash

echo "Begin setting variables.."
. ../../../scripts/set-variables.sh "lz"

S3StackName="cf-$DeploymentRootName-$AccountShortHand-s3"
S3StackPath="../infra/cf-$AccountShortHand-s3.yml"

GlueStackName="cf-$DeploymentRootName-$AccountShortHand-glue"
GlueStackPath="../infra/cf-$AccountShortHand-glue.yml"
echo "End setting variables."

echo "Deleting Glue stack.."
CompId="lz-glue"
aws cloudformation delete-stack --stack-name $GlueStackName --output json
aws cloudformation wait stack-delete-complete --stack-name $GlueStackName --output json --no-paginate 
echo "Glue stack deleted."

# Delete resource bucket objects (Curlys catch any error)
{
    echo "Deleting S3 resource bucket objects.."
    aws s3 rm $ResourceBucketURI --recursive
} || {
    echo "Error deleting resource bucket objects. It is likely already deleted. Check."
}

echo "Deleting S3 stack.."
CompId="lz-s3"
aws cloudformation delete-stack --stack-name $S3StackName
aws cloudformation wait stack-delete-complete --stack-name $S3StackName --output json --no-paginate 
echo "S3 stack deleted."