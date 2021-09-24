###
# File prints Lake Formation permissions on the CLI configured AWS account
# Source Link: https://docs.aws.amazon.com/lake-formation/latest/dg/viewing-permissions.html
# See also: https://awscli.amazonaws.com/v2/documentation/api/2.1.29/reference/lakeformation/list-permissions.html


aws lakeformation list-permissions  --resource-type TABLE --resource '{ "Table": {"DatabaseName":"logs", "Name":"alexa-logs", "CatalogId":"123456789012"}}'