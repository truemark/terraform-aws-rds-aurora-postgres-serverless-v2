data "aws_kms_key" "db" {
  key_id = var.kms_key_alias
}

data "aws_rds_engine_version" "postgresql" {
  engine  = "aurora-postgresql"
  version = var.postgres_engine_version
}

resource "aws_rds_cluster" "cluster" {
  skip_final_snapshot              = true
  cluster_identifier               = var.cluster_identifier
  engine                           = data.aws_rds_engine_version.postgresql.engine
  engine_mode                      = var.cluster_engine_mode
  database_name                    = var.cluster_identifier
  deletion_protection              = var.deletion_protection
  kms_key_id                       = data.aws_kms_key.db.arn
  storage_encrypted                = true
  tags                             = var.tags
  master_username                  = var.master_username
  master_password                  = random_password.db.result
  db_cluster_parameter_group_name  = aws_rds_cluster_parameter_group.cluster.name
  db_instance_parameter_group_name = aws_db_parameter_group.db.name
  db_subnet_group_name             = aws_db_subnet_group.cluster.name
  vpc_security_group_ids           = concat([aws_security_group.db.id], var.security_group_ids)
  serverlessv2_scaling_configuration {
    max_capacity = var.max_capacity
    min_capacity = var.min_capacity
  }
}

resource "aws_rds_cluster_instance" "writer" {
  count = var.writer_instance_count

  # Setting promotion tier to 0 makes the instance eligible to become a writer.
  promotion_tier               = 0
  cluster_identifier           = aws_rds_cluster.cluster.cluster_identifier
  identifier_prefix            = "${aws_rds_cluster.cluster.cluster_identifier}-"
  instance_class               = var.cluster_engine_mode == "provisioned" ? var.writer_instance_class : var.cluster_engine_mode
  engine                       = aws_rds_cluster.cluster.engine
  engine_version               = aws_rds_cluster.cluster.engine_version
  db_subnet_group_name         = aws_db_subnet_group.cluster.name
  db_parameter_group_name      = aws_db_parameter_group.db.name
  performance_insights_enabled = var.performance_insights_enabled
}

resource "aws_rds_cluster_instance" "reader" {
  count = var.reader_instance_count

  # Any promotion tier above 1 is a reader, and cannot become a writer.
  # If the cluster comes up with a reader instance as the writer, initiate a failover.
  promotion_tier               = 2
  cluster_identifier           = aws_rds_cluster.cluster.cluster_identifier
  identifier_prefix            = "${aws_rds_cluster.cluster.cluster_identifier}-"
  instance_class               = var.reader_engine_mode == "provisioned" ? var.writer_instance_class : var.reader_engine_mode
  engine                       = aws_rds_cluster.cluster.engine
  engine_version               = aws_rds_cluster.cluster.engine_version
  db_subnet_group_name         = aws_db_subnet_group.cluster.name
  db_parameter_group_name      = aws_db_parameter_group.db.name
  performance_insights_enabled = var.performance_insights_enabled
}

resource "aws_db_parameter_group" "db" {
  name        = var.cluster_identifier
  family      = var.family
  description = "Terraform managed instance parameter group for ${var.cluster_identifier}"
  dynamic "parameter" {
    for_each = var.db_instance_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }
  tags = merge(var.tags, var.db_parameter_group_tags)
}

resource "aws_rds_cluster_parameter_group" "cluster" {
  name        = var.cluster_identifier
  family      = var.family
  description = "Terraform managed cluster parameter group for ${var.cluster_identifier}"
  dynamic "parameter" {
    for_each = var.rds_cluster_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }
  tags = merge(var.tags, var.rds_cluster_parameter_group_tags)
}

resource "aws_db_subnet_group" "cluster" {
  name       = var.cluster_identifier
  subnet_ids = var.subnet_ids
}

resource "aws_secretsmanager_secret" "db" {
  name_prefix = "database/${aws_rds_cluster.cluster.cluster_identifier}/master-"
  description = "Master password for ${aws_rds_cluster.cluster.cluster_identifier}. Managed by Terraform."
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    host     = aws_rds_cluster.cluster.endpoint
    port     = aws_rds_cluster.cluster.port
    dbname   = aws_rds_cluster.cluster.cluster_identifier
    username = aws_rds_cluster.cluster.master_username
    password = random_password.db.result

  })
}

resource "random_password" "db" {
  length  = 12
  special = true
}

resource "aws_security_group" "db" {
  name   = var.cluster_identifier
  vpc_id = var.vpc_id
  tags   = var.tags

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = var.ingress_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = var.egress_cidr_blocks
  }
}
