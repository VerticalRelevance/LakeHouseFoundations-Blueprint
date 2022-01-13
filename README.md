# AWS-LakeHouse-Ref-Arch

## Purpose
The purpose of this project is to create a reference architecture to showcase the benefits of a modern-day Data LakeHouse Architecture.

## Overview
Over the past several years, Financial Services continues to accumulate large amounts of data located in various silos and warehouses. Core banking systems generate terabytes of machine data every day. This data represents a large, untapped opportunity for financial institutions looking to quickly diagnose problems, provide near-real-time analytics, as well as detect advanced security threats and fraud.

Traditional data warehouse and data lake strategies often require frequent operational overhead, and a large-scale data warehouse creates an additional layer between data lake producers and data lake consumers. This can ultimately result in a high-cost model that consistently increases with the size of your warehouse.

Lake House architectures can minimize (and in some small-scale situations [with Athena] eliminate), the necessity for a data warehouse. By leveraging AWS features such as access permission GRANTS, Lake Formation resource sharing, and Redshift-Spectrum or Athena, organizations can effectively eliminate the need for data transfers between a data lake and a data warehouse. This dramatically reduces the cost of data lake utilization. The recognition of this cost-saver will surely drive demand from businness leaders in the near future. Furthermore, cost-sharing options and configurations within Cloudformation templates allow for AWS-account, IaC-managed cost delegation. The business impacts of this capability are enormous. 

### Future release of Lake Formation Governed Tables
The upcoming GA release of Lake Formation 'Governed Tables', row-level (as well as prior-existing table and columbn level) permissions will be fully supported in AWS. Essentially, this means that a data lake in S3 will soon be able to be leveraged as a OLTP data source, rather than serve simply as an OLAP data source.

# Infrastructure
Below is the target infrastructure diagram.

![TARGET ARCH DIAGRAM]

See the section on folder and file structures below for more information on components shown above.

## The Concept of a Data Mesh
In the diagram shown above, the Governance account delegates access to the curated bucket in the Lakehouse account, to the consumer account. **That alone does not explain the concept of a data mesh**. Rather, a data mesh is the ability of the Governance account's Data Lake Admin to delegate GRANT priveledges to consumer accounts' Data Domain Admins. Thus allowing the maintenance of access to shared resources to be delegated to any number of consumer account Data Lake Administrators. 

This facilitates the ability of large organizations to be able to delegate access management to consumer accounts. **One thing to note here is that this may have an impact on how organizations should setup thier AWS accounts, if it within the scope-of-work.**

# Source code structure & conventions
## Naming Conventions
Names for resource definitions in any of the templates in this repository will be structured by the following convention:
**"${Env}-${DeploymentRootName}-${CompId}-<<ResourceName>>-${AWS::AccountId}-${Region}"**
Note that, in a pipeline executing an SDLC through to multiple environments, it is intended that the build script (deploy.sh, in our case) pass the relevant parameter values to the Cloudformation deployments, based on what environment the CodeBuild deployment is targeting.
Where:
- Env - The environment the templates are deployed in.
- DeploymentRootName - Description: Root name of project/component deployment
- CompId - The logical identifier of the infrastructure template. See the next section for further detail.
- ResourceName - Refers to the component-specific logical name of the resource. For example, "glueJob1"
- ${AWS::AccountId} - Refers to the account the resource is being deployed from. For this project, all cloudformation deployments only deploy resources into their respective accounts.
- ${AWS::Region} - The region to deploy resources into. This project has been tested in us-east-1 and us-east-2.

## Folder Structure
To keep consistent and manageable, account-specific scripts and IaC templates are separated into distinct folders. The following folder structure applies to all four accounts, where `<<accountFolder>>` is one of 'lz', 'lakehouse', 'governance', 'consumer':
- `src/accounts/<<accountFolder>>/infra`
- `src/accounts/<<accountFolder>>/pipeline`

Each accounts 'infra' folder has several Cloudformation 'component' templates. Each accounts 'pipeline' folder also has a standard set of files. The standard files in each accounts' pipeline folder are:
- deploy.sh - Runs the deployment of the account Cloudformation templates, within the target region.
- destroy.sh - Runs the tear-down of the account Cloudformation templates, within the target region.
- set-local-variables.sh - Sets account-specific environment variables needed for both the deploy.sh, and destroy.sh script to execute properly.
- stack-status.sh - Lists the stack status of all stacks relevant to the AWS account.

## Universal Template Parameters
Each of the infrastructure templates in this repository contain the following parameters:

  Env:
    Description: The environment in which the account is being deployed.
    Type: String
    Default: dev
    AllowedValues:
      - dev
      - qa
      - prod
  DeploymentRootName:
    Description: Root name of project/component deployment
    Type: String
    Default: lakehouse
  AccountShorthand:
    Description: Abbreviated logical account identifier
    Type: String
    Default: <<Can be one of: lz, lh, gov, cons>>
  Region:
    Description: The region for the template to be deployed.
    Type: String
    Default: ...
    AllowedValues:
      - us-east-2
      - us-east-1
  CompId:
    Description: This templates' component identifier string
    Type: String
    Default: ...
  ResourceBucketName:
    Description: The name of the deployment resource bucket.
    Type: String

## Account Folder Structure
See the following README.md doc links for futher details regarding specific account deployment/configuration details:
- [Landing Zone Account Docs]
- [Lake House Account Docs]
- [Governance Account Docs]
- [Consumer Account Docs]

## Setup and Tear-Down
This project was built with the intention of it being a reference. As such, all of the setup and tear-down resources have been build into Bash scripts. This allows 2 things: 1) The ability to run the entire setup and tear-down from your location workstation and 2) The ability to adopt any of the Bash scripting into and CI/CD tool of your choice. 

See the subsections below for information on setup & tear down of the entire project, across all four accounts, in 2 regions. 
Be sure to look at the account-specific readme file in the respective account directory for account-specific details on setup & tear-down instructions.

### Setup & Deployment (from local workstation)

#### Bootstrapping Scripts

Make sure to take the time to setup your execution environment correctly before attempting to deploy or destroy resources with these files.
- [describe-lf-permissions.sh] - Performs a specific CLI call to list-permissions on the active credentials in the terminal.
- [get-vpc-info.sh]: Returns VPC info on the active region with the active credentials in the terminal.
- [run-cfnnag.sh]: Takes a single argument as the input path to a Cloudformation template to perform a static unit test of the template.
- [set-variables.sh]: A script used across all account pipeline/deploy.sh and pipeline/destroy.sh scripts. Sets common variables. 
- [test-deploy-all.sh]: A script to deploy all resources to all accounts, in two regions. To perform a single-region deployment, comment out the same regional deployments for all the account deployments. **Please note the setup section within this file must be completed before running this file.**
- [test-destroy-all.sh]: A script to tear-down all resources from all accounts, in both regions. The script will continue to run, and does not currently error, if a deployment is not found. **Please note the setup section within the test-deploy-all.sh file must be completed before running this file.**
- [test-status-all.sh]: Checks the status of all component templates for all regions in all accounts.

#### Data Ingestion Process
The data flow pipeline example data is provided in 2 files for 2 different sources.
1) S3 data in JSON format found at [Sample HR JSON Data Set].
2) (Currently in progress) Aurora Postgresql data found in the [Sample HR PG Data Set].

Glue Workflows are deployed into the Landing Zone, Lake House, and Governance accounts. All three of the account Glue Workflows are orchestrated sequentionally by a step-function deployed in the Lake House account. At a high-level, the data ingestion process is automated by this step-function. See the next section for more detail.

#### Orchestration of the Data Flow Pipeline
The following diagram illustrates the orchestration of the three Glue Workflows deployed across, the three relevant accounts:
![GLUE WORKFLOW ORCHESTRATION]

The three high-level steps involved are:
1) Trigger the Glue Workflow in the Landing Zone Account, which currently ingests data from a provider S3 bucket into producer S3 bucket, and the pushes the data into the Lake House account 'raw zone' S3 bucket.
2) Trigger the Lake House account Glue Workflow, which takes the data from the 'raw zone' bucket, pushes the data to the 'transformed zone' bucket, and finally pulls data from the 'transformed zone' bucket into the 'curated zone' bucket.
3) Finally, trigger the Glue Workflow in the Data Governance account. This Glue Workflow triggers a crawler to populate the data catalog in the Governance account with the 'curated zone' S3 bucket data schema.

#### Governance Account Lake Formation Configuration
The settings for the Governance Account Lake Formation configurations have been copied into the [Lake Formation Permission Settings] Excel spreadsheet. Please refer to this file for details on the Permissions Setup.

#### Consumer Account Configuration

##### Lake Formation Setup
The settings for the Consumer Account Lake Formation configurations have been copied into the [Lake Formation Permission Settings] Excel spreadsheet. Please refer to this file for details on the Permissions Setup.

##### Consumer Account Redshift Setup
Once the Redshift cluster is deployed into the Consumer account, an external table must be created. You must create a *Resource Link* in the Lake Formation Catalog of the shared RAM resource. In our case, a resource link named 'hr-data-resource-link' was created. Assuming you were also your resource link name, you would create the Redshift External table with the commands found in the [Redshift Setup SQL] file.

# Reference

## Links

## Bootstrapping Scripts
- [describe-lf-permissions.sh]: ./src/accounts/describe-lf-permissions.sh
- [get-vpc-info.sh]: ./src/accounts/get-vpc-info.sh
- [run-cfnnag.sh]: ./src/accounts/run-cfnnag.sh
- [set-variables.sh]: ./src/accounts/set-variables.sh
- [test-deploy-all.sh]: ./src/accounts/test-deploy-all.sh
- [test-destroy-all.sh]: ./src/accounts/test-destroy-all.sh
- [test-status-all.sh]: ./src/accounts/test-status-all.sh

## Extended Documentation Links
- [Landing Zone Account Docs]: ./src/accounts/governance/README.md
- [Lake House Account Docs]: ./src/accounts/lakehouse/README.md
- [Governance Account Docs]: ./src/accounts/lz/README.md
- [Consumer Account Docs]: ./src/accounts/consumer/README.md
- [Lake Formation Permission Settings]: ./resources/LakeHouse_LakeFormation_Settings.xlsx

## Images
[TARGET ARCH DIAGRAM]: ./resources/images/lakehouse-ref-arch-1.png "Reference Architecture Diagram"
[THE LAKE HOUSE APPROACH]: ./resources/images/aws-the-lake-house-approach.png "\"The Lake House Approach\""
[GLUE WORKFLOW ORCHESTRATION]: ./resources/images/step-function-glue-workflow-orchestration.png "Data Ingestion Orchestration with a Step Function"

## Data Sources
- [Sample HR JSON Data Set]: ./resources/datasets/hr_data\sample-json
- [Sample HR PG Data Set]: ./src/accounts/lz/infra/cf-lz-rds-postgres-setup.sql
- [Redshift Setup SQL]: ./src/accounts/consumer/infra/redshift-setup.sql

### Lake House Architecture
- [Redshift/Lake House Architecture]: https://aws.amazon.com/redshift/lake-house-architecture/ 
- [Data Lake and Data Mesh Architectures]: https://aws.amazon.com/blogs/big-data/design-a-data-mesh-architecture-using-aws-lake-formation-and-aws-glue/
- [Databricks Definitive Lake House Concepts]: https://databricks.com/research/lakehouse-a-new-generation-of-open-platforms-that-unify-data-warehousing-and-advanced-analytics
- [Lake House Self-Service Analytics Power Point]: https://pages.awscloud.com/rs/112-TZM-766/images/EV_deploy-lake-house-architecture-to-enable-self-service-analytics-with-aws-lake-formation_Jul-2021.pdf

### Lakeformation Setup
- [Changing default Lakeformation Security Settings]: https://docs.aws.amazon.com/lake-formation/latest/dg/change-settings.html 
- [Resource Linking a Shared Catalog Database]: https://docs.aws.amazon.com/lake-formation/latest/dg/creating-resource-links.html
- [Sharing Catalog Resources X-ACNT]: https://docs.aws.amazon.com/lake-formation/latest/dg/sharing-catalog-resources.html
- [Video - Data Mesh Architecture on AWS]: https://www.youtube.com/watch?v=YPYODx4Pfdc
- [Lake Formation Governed Tables]: https://aws.amazon.com/blogs/big-data/part-1-effective-data-lakes-using-aws-lake-formation-part-1-getting-started-with-governed-tables/

### Resource Security Setup Links
#### Cross-account LakeFormation Documentation
- [X-ACNT LAKEFORMATION DOCS]: https://docs.aws.amazon.com/lake-formation/latest/dg/access-control-cross-account.html
#### AWS MSK
- [MSK CF TLS CONGIF]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-msk-cluster-tls.html

### LakeFormation Integration
#### Redshift Spectrum
- [Spectrum/S3 Minimum Permissions]: https://docs.aws.amazon.com/redshift/latest/dg/c-spectrum-iam-policies.html#spectrum-iam-policies-minimum-permissions
- [Spectrum/LakeFormation]: https://docs.aws.amazon.com/redshift/latest/dg/spectrum-lake-formation.html
- [Athena Federated Query??]: https://github.com/awslabs/aws-athena-query-federation/blob/master/athena-example/athena-example.yaml
- [AWS RedshiftSpectrum POC]: https://github.com/aws-samples/aws-redshift-spectrum-poc/blob/master/cf-templates/redshift-spectrum-poc-env.template
#### LakeFormation/Redshift-Spectrum/Athena
- [To create an IAM role for Amazon Redshift using an AWS Glue Data Catalog enabled for AWS Lake Formation]: https://docs.aws.amazon.com/redshift/latest/dg/c-getting-started-using-spectrum-create-role.html#spectrum-get-started-create-role-lake-formation

### Misc
- [DataBrew Blog with Example CF Stack]: https://aws.amazon.com/blogs/big-data/preparing-data-for-ml-models-using-aws-glue-databrew-in-a-jupyter-notebook/