#!/bin/bash

# Set Variables
. ../../../scripts/set-variables.sh

echo "Deleting Glue stack.."
aws cloudformation delete-stack --stack-name "dev-lakehouse-lz-glue" --output json
aws cloudformation wait stack-delete-complete --stack-name "dev-lakehouse-lz-glue" --output json --no-paginate 
echo "Glue stack deleted."

# Delete resource bucket objects (Curlys catch any error)
{
    echo "Deleting S3 resource bucket objects.."
    aws s3 rm $ResourceBucketURI --recursive
} || {
    echo "Error deleting resource bucket objects. It is likely already deleted. Check."
}

echo "Deleting S3 stack.."
aws cloudformation delete-stack --stack-name "dev-lakehouse-lz-s3"
aws cloudformation wait stack-delete-complete --stack-name "dev-lakehouse-lz-s3" --output json --no-paginate 
echo "S3 stack deleted."