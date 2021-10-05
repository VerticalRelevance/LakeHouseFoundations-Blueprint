#!/bin/bash

echo "Begin setting variables.."
. ../../../scripts/set-variables.sh "gov"

LfStackName="$Env-$DeploymentRootName-$AccountShorthand-lf"
LfStackPath="../infra/cf-$AccountShorthand-lakeformation.yml"

echo "End setting variables."