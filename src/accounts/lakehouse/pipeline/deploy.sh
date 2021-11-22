#!/bin/bash


# Require 1 argument
set -o nounset
# Redshift Availability Zone
pAvailabilityZone="$1"

BuildTimestamp=$(date +%s)

. ./set-local-variables.sh

echo "Deploying S3 stack.."
CompId="$AccountShorthand-s3"
aws cloudformation deploy \
    --stack-name $S3StackName \
    --template-file $S3StackPath \
    --parameter-overrides "CompId=$CompId" "Env=$Env" "Region=$Region" "ResourceBucketName=$ResourceBucketName"\
    --capabilities CAPABILITY_NAMED_IAM

echo "Syncing resource files to S3 resource bucket.."
aws s3 sync "../scripts" "$ResourceBucketURI/$AccountShorthand-scripts"

WorkflowInitiatorFileName="cf-$AccountShorthand-orch-glue-operator"
WorkflowInitiatorZipFileName="$WorkflowInitiatorFileName-$BuildTimestamp.zip"
rm -rf ./*.zip
zip a -r "$WorkflowInitiatorZipFileName" "../infra/*.py"
WorkflowInitiatorS3Location="$AccountShorthand-scripts/$WorkflowInitiatorZipFileName"
aws s3 cp "$WorkflowInitiatorZipFileName" "$ResourceBucketURI/$WorkflowInitiatorS3Location"
aws s3 cp "../infra/cf-$AccountShorthand-orch-state-machine.json" $StateMachineS3Uri
echo "Resource files synced to S3 resource bucket."

echo "Deploying Glue stack.."
CompId="$AccountShorthand-glue"
aws cloudformation deploy \
    --stack-name $GlueStackName \
    --template-file $GlueStackPath \
    --parameter-overrides \
        "CompId=$CompId"\
        "Env=$Env" "Region=$Region"\
        "ResourceBucketName=$ResourceBucketName"\
    --capabilities CAPABILITY_NAMED_IAM

echo "Deploying orchestration stack.."
StateMachineS3Key="$AccountShorthand-scripts/cf-lh-orch-state-machine-$BuildTimestamp.json"
StateMachineS3Uri="$ResourceBucketURI/$StateMachineS3Key"
aws s3 cp "../infra/cf-lh-orch-state-machine.json" $StateMachineS3Uri
CompId="$AccountShorthand-orch"
aws cloudformation deploy \
    --stack-name $OrchestrationStackName \
    --template-file $OrchestrationStackPath \
    --parameter-overrides \
        "CompId=$CompId"\
        "Env=$Env" "Region=$Region"\
        "ResourceBucketName=$ResourceBucketName"\
        "StateMachineS3Key=$StateMachineS3Key"\
        "WorkflowInitiatorS3Location=$WorkflowInitiatorS3Location" \
        "WorkfowInitiatorFileName=$WorkflowInitiatorFileName" \
    --capabilities CAPABILITY_NAMED_IAM

echo "Deploying Redshift stack.."
# ! Do not create key pair here. This is for the reference architecture automation. Replace KeyPairName with name of predefined key pair.
KeyPairName="$Env-$DeploymentRootName-$CompId-redshift-bastion-keypair"
aws ec2 create-key-pair --key-name "$KeyPairName"
CompId="$AccountShorthand-redshift"
aws cloudformation deploy \
    --stack-name $RedshiftStackName \
    --template-file $RedshiftStackPath \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "CompId=$CompId" "Env=$Env" \
        "pAvailabilityZone=$pAvailabilityZone" \
        "pBastionHostEC2KeyPair=$KeyPairName"


# #!/bin/bash


# # Require 1 argument
# set -o nounset
# # Redshift Availability Zone
# pAvailabilityZone="$1"

# BuildTimestamp=$(date +%s)

# . ./set-local-variables.sh

# echo "Deploying S3 stack.."
# CompId="$AccountShorthand-s3"
# aws cloudformation deploy \
#     --stack-name $S3StackName \
#     --template-file $S3StackPath \
#     --parameter-overrides "CompId=$CompId" "Env=$Env" "Region=$Region" "ResourceBucketName=$ResourceBucketName"\
#     --capabilities CAPABILITY_NAMED_IAM

# echo "Syncing resource files to S3 resource bucket.."
# aws s3 sync "../scripts" "$ResourceBucketURI/$AccountShorthand-scripts"
# echo "Resource files synced to S3 resource bucket."

# echo "Deploying Glue stack.."
# WorkflowInitiatorFileName="cf-$AccountShorthand-orch-glue-operator"
# WorkflowInitiatorZipFileName="$WorkflowInitiatorFileName-$BuildTimestamp.zip"
# rm -rf ./*.zip
# zip a -r "$WorkflowInitiatorZipFileName" "../infra/*.py"
# WorkflowInitiatorS3Location="$AccountShorthand-scripts/$WorkflowInitiatorZipFileName"
# aws s3 cp "$WorkflowInitiatorZipFileName" "$ResourceBucketURI/$WorkflowInitiatorS3Location"
# aws s3 cp "../infra/cf-$AccountShorthand-orch-state-machine.json" $StateMachineS3Uri
# CompId="$AccountShorthand-glue"
# aws cloudformation deploy \
#     --stack-name $GlueStackName \
#     --template-file $GlueStackPath \
#     --capabilities CAPABILITY_NAMED_IAM \
#     --parameter-overrides \
#         "CompId=$CompId"\
#         "Env=$Env" "Region=$Region"\
#         "ResourceBucketName=$ResourceBucketName" \
#         "WorkflowInitiatorS3Location=$WorkflowInitiatorS3Location" \
#         "WorkfowInitiatorFileName=$WorkflowInitiatorZipFileName"



# echo "Deploying Redshift stack.."
# # ! Do not create key pair here. This is for the reference architecture automation. Replace KeyPairName with name of predefined key pair.
# KeyPairName="$Env-$DeploymentRootName-$CompId-redshift-bastion-keypair"
# aws ec2 create-key-pair --key-name "$KeyPairName"
# CompId="$AccountShorthand-redshift"
# aws cloudformation deploy \
#     --stack-name $RedshiftStackName \
#     --template-file $RedshiftStackPath \
#     --capabilities CAPABILITY_NAMED_IAM \
#     --parameter-overrides "CompId=$CompId" "Env=$Env" \
#         "pAvailabilityZone=$pAvailabilityZone" \
#         "pBastionHostEC2KeyPair=$KeyPairName"