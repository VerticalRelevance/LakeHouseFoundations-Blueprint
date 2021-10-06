#!/bin/bash

echo "Begin setting variables.."
. ../../../scripts/set-variables.sh "gov"

export LfStackName="$Env-$DeploymentRootName-$AccountShorthand-lf"
export LfStackPath="../infra/cf-$AccountShorthand-lakeformation.yml"

echo "End setting variables."