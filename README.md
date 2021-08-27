# AWS-LakeHouse-Ref-Arch
Reference architecture for a data LakeHouse.


# Infrastructure
Below is the target infrastructure diagram.

![arch-img]

Note that The reference architecture includes 4 accounts.

# Folder Structure & File Descriptions

## Infrastructure
Infrastructure definitions are grouped by each account's resources to be provisioned.
- src/infra/lz/cf-lz.yml
- src/infra/lakehouse/cf-lakehouse.yml
- src/infra/governance/cf-governance.yml
- src/infra/consumer/cf-consumer.yml

## Scripts


Currently, each of these infrastructure folders contains a Cloudformation template.



[arch-img]: ./resources/images/lakehouse-ref-arch-1.png "Reference Architecture Diagram"