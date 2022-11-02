# terraform-aws-rds-aurora-postgres-serverless-v2

This repo generates an [Aurora Serverless v2](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.html) postgres cluster. The following parameters are supported:

- cluster_engine_mode
- cluster_identifier
- db_instance_parameters
- db_parameter_group_tags
- deletion_protection
- egress_cidr_blocks
- family
- ingress_cidr_blocks
- kms_key_alias
- master_username
- max_capacity
- min_capacity
- performance_insights_enabled
- performance_insights_retention_period
- port
- postgres_engine_version
- preferred_backup_window
- preferred_maintenance_window
- rds_cluster_parameter_group_tags
- rds_cluster_parameters
- reader_engine_mode
- reader_instance_class
- reader_instance_count
- security_group_ids
- subnet_ids
- tags
- vpc_id
- writer_instance_class
- writer_instance_count