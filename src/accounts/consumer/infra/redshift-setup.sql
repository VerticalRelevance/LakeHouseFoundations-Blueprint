----
-- Redshift Script for creating an external table reference into the Lake Formation consumer Lake Formation catalog.
--  This will reference the shared catalog table from the Governance Account.
--      Replace the iam_role with the iam role created for any developer. Creating multiple external schemas with different roles
--      will allow for role-based views from the Lake Formation Catalog on corresponding role-based external schemas.

CREATE EXTERNAL SCHEMA IF NOT EXISTS hr_data_developer
from DATA CATALOG
database 'hr-data-resource-link'
iam_role 'arn:aws:iam::456886174736:role/dev-lakehouse-cons-lf-lf-developer-456886174736-us-east-2'
region 'us-east-2';

