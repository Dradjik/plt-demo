output "bucket_name" {
  description = "Name of the created bucket"
  value       = scaleway_object_bucket.test_bucket.name
}

output "bucket_endpoint" {
  description = "Endpoint of the created bucket"
  value       = scaleway_object_bucket.test_bucket.endpoint
}

output "instance_ip_id" {
  description = "ID of the created instance IP"
  value       = scaleway_instance_ip.test_ip.id
}

output "instance_ip_address" {
  description = "IP address of the created instance IP"
  value       = scaleway_instance_ip.test_ip.address
}

