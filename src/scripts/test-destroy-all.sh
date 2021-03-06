#!/bin/bash
###
# To use the script below, the following alias definitions must be setup in your terminal scope. Make sure you do this in a script file outside
#   this repository, to ensure you don't push access credentials.
# This file requires 1 argunment.
#  1) testpass - The password for the test users created in the Lake Formation accounts.
###

# alias vrLabLz="""
#   export AWS_ACCESS_KEY_ID="<DO NOT COMMIT YOUR CREDENTIALS HERE>"
#   export AWS_SECRET_ACCESS_KEY="<DO NOT COMMIT YOUR CREDENTIALS HERE>"
#   aws  --profile "vrLabLz" sts get-session-token \
#     --duration 129600  \
#     --output text"""

# alias vrLabLh="""
#   export AWS_ACCESS_KEY_ID="<DO NOT COMMIT YOUR CREDENTIALS HERE>"
#   export AWS_SECRET_ACCESS_KEY="<DO NOT COMMIT YOUR CREDENTIALS HERE>"
#   aws  --profile "vrLabLh" sts get-session-token \
#     --duration 129600  \
#     --output text"""

# alias vrLabGov="""
#   export AWS_ACCESS_KEY_ID="<DO NOT COMMIT YOUR CREDENTIALS HERE>"
#   export AWS_SECRET_ACCESS_KEY="<DO NOT COMMIT YOUR CREDENTIALS HERE>"
#   aws  --profile "vrLabGov" sts get-session-token \
#     --duration 129600  \
#     --output text"""

# alias vrLabCons1="""
#   export AWS_ACCESS_KEY_ID="<DO NOT COMMIT YOUR CREDENTIALS HERE>"
#   export AWS_SECRET_ACCESS_KEY="<DO NOT COMMIT YOUR CREDENTIALS HERE>"
#   aws  --profile "vrLabCons1" sts get-session-token \
#     --duration 129600  \
#     --output text"""

# alias region1="aws configure set region us-east-1"
# alias region2="aws configure set region us-east-2"

# alias deploy=". ./deploy.sh"
# alias list-active-stacks="aws cloudformation list-stacks --stack-status-filter \"CREATE_COMPLETE\" \"UPDATE_COMPLETE\""
# alias list-broken-stacks="aws cloudformation list-stacks --stack-status-filter \"UPDATE_ROLLBACK_COMPLETE\" \"DELETE_FAILED\" \"UPDATE_ROLLBACK_FAILED\" \"CREATE_FAILED\""

###
# Once you've setup the above (OUTSIDE OF THIS REPOSITORY!), you can run the following...
###

alias destroy=". ./destroy.sh"

# Landing Zone Account
vrLabLz
region1
cd ../accounts/lz/pipeline
destroy
region2
destroy
cd ../../../scripts

# Lake House Account
vrLabLh
region1
cd ../accounts/lakehouse/pipeline
destroy
region2
destroy
cd ../../../scripts

# Governance Account
vrLabGov
region1
cd ../accounts/governance/pipeline
destroy
region2
destroy
cd ../../../scripts

# Consumer Account
vrLabCons1
region1
cd ../accounts/consumer/pipeline
destroy
region2
destroy
cd ../../../scripts