#!/bin/bash

. ./set-local-variables.sh

# Delete bucket objects. {Curlys catch any error} || { echo "Error...not gonna kill your script"}
{
    CompId="$AccountShorthand-lf"
    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-logs-$AccountId-$Region" --recursive
    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-lf-bucket-$AccountId-$Region" --recursive
} || {
    echo "Error deleting bucket objects. It is likely already deleted. Check."
}

# Delete Stacks
aws cloudformation delete-stack --stack-name $AthenaStackName
aws cloudformation wait stack-delete-complete --stack-name $AthenaStackName --output json --no-paginate

aws cloudformation delete-stack --stack-name $LfStackName
aws cloudformation wait stack-delete-complete --stack-name $LfStackName --output json --no-paginate

KeyPairName="$Env-$DeploymentRootName-$CompId-redshift-bastion-keypair"
aws ec2 create-key-pair --key-name "$KeyPairName"
aws cloudformation delete-stack --stack-name $SpectrumStackName
aws cloudformation wait stack-delete-complete --stack-name $SpectrumStackName --output json --no-paginate