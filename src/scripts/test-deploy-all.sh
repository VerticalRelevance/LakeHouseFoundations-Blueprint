#!/bin/bash

###
# To use the uncommented script below, the following alias definitions must be setup in your terminal scope. Make sure you do this in a script file outside
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

###
# Once you've setup the above (OUTSIDE OF THIS REPOSITORY!), you can run the following...
###
set -o nounset
alias deploy=". ./deploy.sh"

testpass=$1

if [ ! testpass ]; then
    echo "Supply a test user password as a string argument. Exiting with error."
    exit 0
fi  

# Landing Zone Account
vrLabLz
region1
cd ../accounts/lz/pipeline
deploy
region2
deploy
cd ../../../scripts

# Lake House Account
vrLabLh
region1
cd ../accounts/lakehouse/pipeline
deploy "us-east-1a"
region2
deploy "us-east-2a"
cd ../../../scripts

# Governance Account
vrLabGov
region1
cd ../accounts/governance/pipeline
deploy $testpass
region2
deploy $testpass
cd ../../../scripts

# Consumer Account
vrLabCons1
region1
cd ../accounts/consumer/pipeline
deploy $testpass "us-east-1a"
region2
deploy $testpass "us-east-2a"
cd ../../../scripts

###
# Now setup Lake Formation...
###

### Governance Account
# Ensure the prerequisites are satisfied: Setting up X-account permissions for consumer. See https://docs.aws.amazon.com/lake-formation/latest/dg/cross-account-prereqs.html
# Go to Gov Lake Formation console and add lf-admin as Lake Formation Admin
# Change Default Catalog Settings Remove Default Catalog Behavior in Lake Formation settings. See: https://docs.aws.amazon.com/lake-formation/latest/dg/change-settings.html

### Consumer Account
# Go to Consumer Lake Formation console and add hr-manager as Lake Formation Admin
# Change Default Catalog Settings Remove Default Catalog Behavior in Lake Formation settings. See: https://docs.aws.amazon.com/lake-formation/latest/dg/change-settings.html
# Create a resource link to the database within the Lakeformation console (This is required for shared tables, and is documented here: https://docs.aws.amazon.com/lake-formation/latest/dg/resource-links-about.html)
# Login as the hr-manager and configure access for the developer and business analyst
# 

## Redshift Setup
# Open the console and connect to your database:
# Create the external query (this is the most important thing in the entire reference architecture!)
#    *Note the database name is derived from the jdbc url given in the cluster console details.
# ------
# create external schema hr_data
# from data catalog 
# database '<GlueCatalogDatabaseName>'
# iam_role '<redshiftRoleArn>'
# ------
# You should now be able to run queries against your lakeformation catalog:
# ------
# SELECT * FROM hr_data.<GlueCatalogDatabaseTableName>
# ------
# *Note that the above query will return different results depending on who you are logged in as.


# Once you have completed the above steps, the governance catalog database and tables will be available in the Consumer account.
# You can login with each of the roles to see their respective tables and columns

### Consumer Account Redshift-Spectrum setup
# Open newly created Redshift cluster in the Consumer acount
# 

### Now here are manual steps end-to-end
# Upload sample json to s3



