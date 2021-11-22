#!/bin/bash

. ./set-local-variables.sh

echo "Deleting Athena stack..."
aws cloudformation delete-stack --stack-name $AthenaStackName
aws cloudformation wait stack-delete-complete --stack-name $AthenaStackName --output json --no-paginate
echo "Athena stack deleted."

echo "Deleting Lake Formation stack.."
# Delete bucket objects. {Curlys catch any error} || { echo "Error...not gonna kill your script"}
{
    CompId="$AccountShorthand-lf"
    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-logs-$AccountId-$Region" --recursive
    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-lf-bucket-$AccountId-$Region" --recursive
} || {
    echo "Error deleting bucket objects. It is likely already deleted. Check."
}
aws cloudformation delete-stack --stack-name $LfStackName
aws cloudformation wait stack-delete-complete --stack-name $LfStackName --output json --no-paginate
echo "Lake Formation stack deleted."

echo "Deleting Redshift stack..."
KeyPairName="$Env-$DeploymentRootName-$CompId-redshift-bastion-keypair"
aws ec2 delete-key-pair --key-name "$KeyPairName"
aws cloudformation delete-stack --stack-name $SpectrumStackName
aws cloudformation wait stack-delete-complete --stack-name $SpectrumStackName --output json --no-paginate
echo "Redshift stack deleted."
