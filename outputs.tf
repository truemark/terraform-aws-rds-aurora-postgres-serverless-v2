output "cluster_identifier" {
  description = "The cluster identifier"
  value       = module.db.id
}

output "cluster_members" {
  description = "Members of the cluster"
  value       = module.db.cluster_members
}

output "cluster_resource_id" {
  description = "The RDS Cluster Resource ID."
  value       = module.db.cluster_resource_id
}

output "endpoint" {
  description = "The DNS address of the writer instance."
  value       = module.db.endpoint
}

output "reader_endpoint" {
  description = "A read0only endpoint for the Aurora cluster, automatically load-balanced across replicas."
  value       = module.db.reader_endpoint
}

output "replication_source_identifier" {
  description = "ARN of the source DB cluster or DB instance if this DB cluster is created as a Read Replica."
  value       = module.db.replication_source_identifier
}
