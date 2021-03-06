# AWS-LakeHouse-Ref-Arch - Landing Zone Account

This set of components represents the Lake House Reference architecture Landing Zone account.

# Installation

## Requirements
- You must have your AWS CLI profile configured with your target account credentials.
- You must have priveledges to create the nessecary resources within the stacks, including the priveledge to create roles.

## Deployment
Follow the steps below to install the baseline infrastructure required to setup the target account resource definitons.

- Configure your AWS profile in the CLI with the target account, and target region.
- Navigate to the ./scripts folder and run the deploy.sh shell script.

## Tear-Down
Follow the steps below to install the baseline infrastructure required to delete the landing zone account resource definitions.

- Configure your AWS profile in the CLI with the target target account, and target region.
- Navigate to the ./scripts folder and run the destroy.sh shell script.

# Usage

## Glue Workflow
- Navigate to Glue in the console and click on 'Workflows' in the left-hand navigation menu.
- Select the workflow you've deployed, and select 'Run'.

Note that, in order to see the workflow execute, you must select the workflow, click the 'History' tab, select the running workflow, and click 'View Run Details'. This will allow you to see the progression of the workflow.