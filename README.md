# AWS-LakeHouse-Ref-Arch
Reference architecture for a data LakeHouse.


# Infrastructure
Below is the target infrastructure diagram.

![arch-img]

Note that The reference architecture includes 4 accounts.

## Folder Structure & File Descriptions
Infrastructure definitions are grouped by each account's resources to be provisioned.
- src/infra/lz/cf-lz.yml
- src/infra/lakehouse/cf-lakehouse.yml
- src/infra/governance/cf-governance.yml
- src/infra/consumer/cf-consumer.yml


# Reference

## Links

### AWS LakeHouse Architecture
[Redshift/Lakehouse Architecture]: https://aws.amazon.com/redshift/lake-house-architecture/ 
[Changing default Lakeformation Security Settings]: https://docs.aws.amazon.com/lake-formation/latest/dg/change-settings.html 

### Resource Security Setup Links
#### AWS MSK
[MSK CF TLS CONGIF]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-msk-cluster-tls.html

## Images

[arch-img]: ./resources/images/lakehouse-ref-arch-1.png "Reference Architecture Diagram"