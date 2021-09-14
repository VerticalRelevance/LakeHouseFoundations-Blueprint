# AWS-LakeHouse-Ref-Arch

## Purpose
The purpose of this project is to create a reference architecture that showcases the benefits of a modern-day Data LakeHouse Architecture.

## Overview
As consumers, we are continually shifting to a digital-first mentality. With Financial Services, customers are expected to be able to conduct transactions using a mobile or web-based application. Over the past several years, Financial Services continues to accumulate large amounts of data located in various silos and warehouses. Core banking systems generate terabytes of machine data every day. This data represents a large, untapped opportunity for financial institutions looking to quickly diagnose problems, as well as detect advanced security threats and fraud.

Traditional data warehouse and data lake strategies often require frequent operational overhead, and a data warehouse creates an additional layer between data lake producers and consumers. This can ultimately result in a high-cost model that consistently increases with the size of your warehouse.

Lake House architectures can reduce or eliminate the need for a data warehouse by leveraging object-storage querying mechanisms, eliminating the need for data transfers between a data lake and a data warehouse.

# Infrastructure
Below is the target infrastructure diagram.

![TARGET ARCH DIAGRAM]

See the section on folder and file structures below for more information on components shown above.

# Source code structure & conventions
## Naming Conventions
Names for resource definitions in any of the templates in this repository will be structured by the following convention:
**"${Environment}-${ComponentID}-<ResourceType>-<RelevantSuffix>"**
Note that, in a pipeline executing an SDLC through to multiple environments, it is intended that CodeBuild pass the relevant parameter values to the Cloudformation deployments, based on what environment the CodeBuild deployment is targeting.
Where:
- Env - The environment the templates are deployed in.
- ComponentID - The logical identifier of the infrastructure template. See the next section for further detail.
- ResourceType - Refers to a general name of the resource. For example, "S3"
- RelevantSuffix [Optional] - Added when you need more than one resource definition in the same template of the same type. For example, "dev-consumer-athena-s3-src" and "dev-consumer-athena-s3-2".

## Universal Template Parameters
Each of the infrastructure templates in this repository currently contain the following parameters:
1) ComponentID - The identifier of any template in this repository which represents a logical set of deployment resources. This ComponentID will then be used to define the name of the resource definitions in the template, based on the naming convention for resources documented in the previous section.
2) Environment - The environment the template targets.

## Folder Structure & File Descriptions
Infrastructure definitions are grouped by each account's resources to be provisioned.
## Pipeline scripting files
## Infrastructure Templates
- src/infra/lz/
  - cf-lz-main.yml 
  - cf-lz-datasync.yml
  - cf-lz-msk.yml
- src/infra/lakehouse/
  - cf-lakehouse-s3.yml
  - cf-lakehouse-glue.yml
  - cf-lakehouse-redshift.yml
- src/infra/governance/
  - cf-governance-.yml
- src/infra/consumer/
  - cf-consumer-catalog.yml
  - cf-consumer-athena.yml
  - cf-consumer-redshift.yml
  - cf-consumer-lakeformation.yml



# Reference

## Links

### AWS Lake House Architecture
[Redshift/Lake House Architecture]: https://aws.amazon.com/redshift/lake-house-architecture/ 
[Data Lake and Data Mesh Architectures]: https://aws.amazon.com/blogs/big-data/design-a-data-mesh-architecture-using-aws-lake-formation-and-aws-glue/

### Lakeformation Setup
[Changing default Lakeformation Security Settings]: https://docs.aws.amazon.com/lake-formation/latest/dg/change-settings.html 
[Resource Linking a Shared Catalog Database]: https://docs.aws.amazon.com/lake-formation/latest/dg/creating-resource-links.html
[Sharing Catalog Resources X-ACNT]: https://docs.aws.amazon.com/lake-formation/latest/dg/sharing-catalog-resources.html
[Lake Formation Governed Tables]: https://aws.amazon.com/blogs/big-data/part-1-effective-data-lakes-using-aws-lake-formation-part-1-getting-started-with-governed-tables/

### Resource Security Setup Links
#### Cross-account LakeFormation Documentation
[X-ACNT LAKEFORMATION DOCS]: https://docs.aws.amazon.com/lake-formation/latest/dg/access-control-cross-account.html
#### AWS MSK
[MSK CF TLS CONGIF]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-msk-cluster-tls.html

### LakeFormation Integration
#### Redshift Spectrum
[Spectrum/LakeFormation]: https://docs.aws.amazon.com/redshift/latest/dg/spectrum-lake-formation.html
[Athena Federated Query??]: https://github.com/awslabs/aws-athena-query-federation/blob/master/athena-example/athena-example.yaml
[AWS RedshiftSpectrum POC]: https://github.com/aws-samples/aws-redshift-spectrum-poc/blob/master/cf-templates/redshift-spectrum-poc-env.template
#### LakeFormation/Redshift-Spectrum/Athena
[To create an IAM role for Amazon Redshift using an AWS Glue Data Catalog enabled for AWS Lake Formation]: https://docs.aws.amazon.com/redshift/latest/dg/c-getting-started-using-spectrum-create-role.html#spectrum-get-started-create-role-lake-formation

## Images
[TARGET ARCH DIAGRAM]: ./resources/images/lakehouse-ref-arch-1.png "Reference Architecture Diagram"