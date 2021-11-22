#!/bin/bash

echo "Begin setting variables.."
. ../../../scripts/set-variables.sh "lh"

export S3StackName="$Env-$DeploymentRootName-$AccountShorthand-s3"
export S3StackPath="../infra/cf-$AccountShorthand-s3.yml"

export GlueStackName="$Env-$DeploymentRootName-$AccountShorthand-glue"
export GlueStackPath="../infra/cf-$AccountShorthand-glue.yml"

export OrchestrationStackName="$Env-$DeploymentRootName-$AccountShorthand-orch"
export OrchestrationStackPath="../infra/cf-$AccountShorthand-orch.yml"

export RedshiftStackName="$Env-$DeploymentRootName-$AccountShorthand-redshift"
export RedshiftStackPath="../infra/cf-$AccountShorthand-redshift.yml"

export KeyPairName="$Env-$DeploymentRootName-$CompId-redshift-bastion-keypair-$Region"
echo "End setting variables."