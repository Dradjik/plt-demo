output "vpc_id" {
  description = "ID of the VPC"
  value       = module.drift.vpc_id
}

output "private_network_id" {
  description = "ID of the VPC private network"
  value       = module.drift.private_network_id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = module.drift.security_group_id
}

output "placement_group_id" {
  description = "ID of the placement group"
  value       = module.drift.placement_group_id
}

output "bucket_name" {
  description = "Name of the drift-test bucket"
  value       = module.drift.bucket_name
}

output "registry_namespace_endpoint" {
  description = "Endpoint of the container registry namespace"
  value       = module.drift.registry_namespace_endpoint
}
