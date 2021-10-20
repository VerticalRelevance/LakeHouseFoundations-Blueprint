#!/bin/bash

echo "Begin setting variables.."
. ../../../scripts/set-variables.sh "lz"

export S3StackName="$Env-$DeploymentRootName-$AccountShorthand-s3"
export S3StackPath="../infra/cf-$AccountShorthand-s3.yml"

export GlueStackName="$Env-$DeploymentRootName-$AccountShorthand-glue"
export GlueStackPath="../infra/cf-$AccountShorthand-glue.yml"

export RdsStackName="$Env-$DeploymentRootName-$AccountShorthand-rds-postgres"
export RdsStackPath="../infra/cf-$AccountShorthand-rds-postgres.yml"
echo "End setting variables."