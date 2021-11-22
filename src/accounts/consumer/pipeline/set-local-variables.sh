#!/bin/bash

echo "Begin setting variables.."
. ../../../scripts/set-variables.sh "cons"

export LfStackName="$Env-$DeploymentRootName-$AccountShorthand-lakeformation"
export LfStackPath="../infra/cf-$AccountShorthand-lakeformation.yml"

export AthenaStackName="$Env-$DeploymentRootName-$AccountShorthand-athena"
export AthenaStackPath="../infra/cf-$AccountShorthand-athena.yml"

export SpectrumStackName="$Env-$DeploymentRootName-$AccountShorthand-redshift-spectrum"
export SpectrumStackPath="../infra/cf-$AccountShorthand-redshift-spectrum.yml"

export KeyPairName="$Env-$DeploymentRootName-$CompId-redshift-bastion-keypair-$Region"
echo "End setting variables."