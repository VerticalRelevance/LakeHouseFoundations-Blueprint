# AWS-LakeHouse-Ref-Arch - Governance Account

This set of components represents the Lake House Reference architecture example Consumer account.

# Installation

## Requirements
- You must have your AWS CLI profile configured with your target landing zone account credentials.
- You must have priveledges to create the nessecary resources within the stacks, including the priveledge to create roles.

## Deployment
Follow the steps below to install the baseline infrastructure required to setup the target account resource definitons.

- Configure your AWS profile in the CLI with the target account, and target region.
- Navigate to the ./scripts folder and run the deploy.sh shell script.

## Tear-Down
Follow the steps below to install the baseline infrastructure required to delete the target account resource definitions.

- Configure your AWS profile in the CLI with the target account, and target region.
- Navigate to the ./scripts folder and run the destroy.sh shell script.
