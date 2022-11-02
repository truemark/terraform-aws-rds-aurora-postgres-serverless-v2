variable "cluster_engine_mode" {
  description = "The engine mode config for the cluster: either provisioned or serverless."
  type        = string
  default     = "provisioned"
}

variable "cluster_identifier" {
  description = "The cluster identifier for the cluster to be created."
  type        = string
}

variable "db_instance_parameters" {
  description = "Map of parameters to configure the database instance resource."
  type = list(object({
    name         = string
    value        = string
    apply_method = string
  }))
  default = []
}

variable "db_parameter_group_tags" {
  description = "A map of tags to add to the db_parameter_group resource."
  default     = {}
}

variable "deletion_protection" {
  description = "Toggle to enable deletion protection. The db cannot be deleted when this value is set to true."
  type        = bool
  default     = false
}

variable "egress_cidr_blocks" {
  description = "A list of CIDR blocks which are allowed to access the database"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "family" {
  description = "The database family of the instance and parameter group."
  default     = "aurora-postgresql13"
}

variable "ingress_cidr_blocks" {
  description = "A list of CIDR blocks which are allowed to access the database"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "kms_key_alias" {
  description = "The alias of the KMS encryption key. When specifying kms_key_id, storage_encrypted needs to be set to true."
  type        = string
}

variable "master_username" {
  description = "The name of the master account for the db. Defaults to root."
  type        = string
  default     = "root"
}

variable "max_capacity" {
  description = "The maxiumum capacity for an Aurora DB cluster in serverless DB engine mode. Must be greater than or equal to minimum capacity"
  type        = number
  default     = 4
}

variable "min_capacity" {
  description = "The minimum capacity for an Aurora DB cluster in serverless DB engine mode. Must be less than or equal to the maximum capacity."
  type        = number
  default     = 2
}

variable "performance_insights_enabled" {
  description = "Switch to turn on performance insights."
  type        = bool
  default     = false
}

variable "performance_insights_retention_period" {
  description = "How many days to keep Performance Insights data."
  type        = number
  default     = 7
}

variable "port" {
  description = "The port the instance listens on."
  type        = number
  default     = 5432
}

variable "postgres_engine_version" {
  description = "The version of the postgres cluster engine to create."
  type        = string
  default     = "13.6"
}

variable "preferred_backup_window" {
  description = "When to perform DB backups"
  type        = string
  default     = "09:00-10:00" # 2AM-3AM MST
}

variable "preferred_maintenance_window" {
  description = "When to perform DB maintenance"
  type        = string
  default     = "sat:07:00-sat:09:00" # 12AM-2AM MST
}

variable "rds_cluster_parameter_group_tags" {
  description = "A map of tags to add to the aws_rds_cluster_parameter_group resource if one is created."
  default     = {}
}

variable "rds_cluster_parameters" {
  description = "Map of parameters to configure the cluster resource."
  type = list(object({
    name         = string
    value        = string
    apply_method = string
  }))
  default = []
}

variable "reader_engine_mode" {
  description = "The engine mode config for the readers: either provisioned or db.serverless."
  type        = string
  default     = "db.serverless"
}

variable "reader_instance_class" {
  description = "Instance class of a provisioned cluster reader. This parameter is required if reader_engine_mode is set to provisioned."
  type        = string
}

variable "reader_instance_count" {
  description = "The number of reader instances to create."
  type        = number
  default     = 0
}

variable "security_group_ids" {
  description = "List of security group IDs to apply to the cluster instances."
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "List of subnet IDs to use."
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The ID of the VPC to provision into."
  type        = string
}

variable "writer_instance_class" {
  description = "Instance class of a provisioned cluster writer. This parameter is required if cluster_engine_mode is set to provisioned."
  type        = string
  default     = "db.t3.medium"
}

variable "writer_instance_count" {
  description = "The number of writer instances to create."
  type        = number
  default     = 1
}
