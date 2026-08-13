output "vpc_id" {
  description = "ID of the VPC"
  value       = scaleway_vpc.demo.id
}

output "private_network_id" {
  description = "ID of the VPC private network"
  value       = scaleway_vpc_private_network.demo.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = scaleway_instance_security_group.demo.id
}

output "placement_group_id" {
  description = "ID of the placement group"
  value       = scaleway_instance_placement_group.demo.id
}

output "bucket_name" {
  description = "Name of the drift-test bucket"
  value       = scaleway_object_bucket.demo.name
}

output "registry_namespace_endpoint" {
  description = "Endpoint of the container registry namespace"
  value       = scaleway_registry_namespace.demo.endpoint
}
