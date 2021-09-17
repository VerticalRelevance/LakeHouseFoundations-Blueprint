variable "domain" {
  default = "wonderband"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_elasticsearch_domain" "example" {
  access_policies = "{\"Statement\":[{\"Action\":\"es:*\",\"Condition\":{\"IpAddress\":{\"aws:SourceIp\":\"99.10.229.198\"}},\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"*\"},\"Resource\":\"arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/wonderband/*\"}],\"Version\":\"2012-10-17\"}"

  cluster_config {
    instance_type = "t2.small.elasticsearch"
    instance_count = 1
    dedicated_master_enabled = false
    dedicated_master_count = 0
    dedicated_master_type = ""
    zone_awareness_enabled = false
  }

  cognito_options {
    enabled = false
    identity_pool_id = ""
    role_arn = ""
    user_pool_id = ""
  }

  domain_name = var.domain

  ebs_options {
    ebs_enabled = true
    volume_size = 10
    volume_type = "gp2"
    iops = 0
  }

  elasticsearch_version = "7.4"

  encrypt_at_rest {
    enabled = false
  }


  node_to_node_encryption {
    enabled = false
  }

  snapshot_options {
    automated_snapshot_start_hour = 0
  }
}
