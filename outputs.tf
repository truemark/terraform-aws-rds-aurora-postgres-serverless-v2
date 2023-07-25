output "availability_zones" {
  description = "The availability zones of the instance."
  value       = aws_rds_cluster.cluster.availability_zones
}

output "cluster_identifier" {
  description = "The RDS Cluster Identifier."
  value       = aws_rds_cluster.cluster.cluster_identifier
}

output "cluster_members" {
  description = "List of RDS instasnces that are part of this cluster."
  value       = aws_rds_cluster.cluster.cluster_members 
}

output "endpoint" {
  description = "The DNS address of the RDS instance."
  value       = aws_rds_cluster.cluster.endpoint
}

output "engine" {
  description = "The database engine."
  value       = aws_rds_cluster.cluster.engine
}

output "engine_version_actual" {
  description = "The running version of the database."
  value       = aws_rds_cluster.cluster.engine_version_actual
}

output "port" {
  description = "The port the database is listening on."
  value       = aws_rds_cluster.cluster.port
}

output "reader_endpoint" {
  description = "A read only endpoint for the cluster, automatically load balanced across replicas."
  value       = aws_rds_cluster.cluster.reader_endpoint
}

output "replication_source_identifier" {
  description = "ARN of the source DB cluster or DB instance if this DB cluster is created as a Read Replica."
  value       = aws_rds_cluster.cluster.replication_source_identifier
}
