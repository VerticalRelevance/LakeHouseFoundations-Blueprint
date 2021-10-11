#!/bin/bash

echo "Begin setting variables.."
. ../../../scripts/set-variables.sh "gov"

export S3StackName="$Env-$DeploymentRootName-$AccountShorthand-s3"
export S3StackPath="../infra/cf-$AccountShorthand-s3.yml"

export LfStackName="$Env-$DeploymentRootName-$AccountShorthand-lf"
export LfStackPath="../infra/cf-$AccountShorthand-lakeformation.yml"

echo "End setting variables."