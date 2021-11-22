

CREATE EXTERNAL SCHEMA IF NOT EXISTS hr_data_developer
from DATA CATALOG
database 'hr-data-resource-link'
iam_role 'arn:aws:iam::456886174736:role/dev-lakehouse-cons-lf-lf-developer-456886174736-us-east-2'
region 'us-east-2';

