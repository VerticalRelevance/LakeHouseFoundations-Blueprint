#!/bin/bash

echo "Begin setting variables.."
. ../../../scripts/set-variables.sh "lz"

S3StackName="$Env-$DeploymentRootName-$AccountShorthand-s3"
S3StackPath="../infra/cf-$AccountShorthand-s3.yml"

GlueStackName="$Env-$DeploymentRootName-$AccountShorthand-glue"
GlueStackPath="../infra/cf-$AccountShorthand-glue.yml"
echo "End setting variables."