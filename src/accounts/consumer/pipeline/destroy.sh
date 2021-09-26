#!/bin/bash

echo "Begin setting variables.."
. ../../../scripts/set-variables.sh "cons"

LfStackName="${Env}-$DeploymentRootName-$AccountShorthand-lakeformation"
LfStackPath="../infra/cf-$AccountShorthand-lakeformation.yml"

AthenaStackName="${Env}-$DeploymentRootName-$AccountShorthand-athena"
AthenaStackPath="../infra/cf-$AccountShorthand-athena.yml"

SpectrumStackName="${Env}-$DeploymentRootName-$AccountShorthand-redshift-spectrum"
SpectrumStackPath="../infra/cf-$AccountShorthand-redshift-spectrum.yml"
echo "End setting variables."

# Delete bucket objects (Curlys catch any error)
{
    CompId="$AccountShorthand-lf"
    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-logs-$AccountId-$Region" --recursive
    aws s3 rm "s3://$Env-$DeploymentRootName-$CompId-lf-bucket-$AccountId-$Region" --recursive
} || {
    echo "Error deleting bucket objects. It is likely already deleted. Check."
}


aws cloudformation delete-stack --stack-name $AthenaStackName
aws cloudformation wait stack-delete-complete --stack-name $AthenaStackName --output json --no-paginate 
aws cloudformation delete-stack --stack-name $SpectrumStackName
aws cloudformation wait stack-delete-complete --stack-name $SpectrumStackName --output json --no-paginate 
aws cloudformation delete-stack --stack-name $LfStackName
aws cloudformation wait stack-delete-complete --stack-name $LfStackName --output json --no-paginate 