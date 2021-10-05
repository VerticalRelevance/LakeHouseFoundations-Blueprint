#!/bin/bash

echo "Begin setting variables.."
. ../../../scripts/set-variables.sh "cons"

LfStackName="$Env-$DeploymentRootName-$AccountShorthand-lakeformation"
LfStackPath="../infra/cf-$AccountShorthand-lakeformation.yml"

AthenaStackName="$Env-$DeploymentRootName-$AccountShorthand-athena"
AthenaStackPath="../infra/cf-$AccountShorthand-athena.yml"

SpectrumStackName="$Env-$DeploymentRootName-$AccountShorthand-redshift-spectrum"
SpectrumStackPath="../infra/cf-$AccountShorthand-redshift-spectrum.yml"
echo "End setting variables."