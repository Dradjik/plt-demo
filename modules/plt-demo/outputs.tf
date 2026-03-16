output "bucket_name" {
  description = "Name of the created bucket"
  value       = scaleway_object_bucket.test_bucket.name
}

output "bucket_endpoint" {
  description = "Endpoint of the created bucket"
  value       = scaleway_object_bucket.test_bucket.endpoint
}

output "vm_id" {
  description = "ID of the created VM instance"
  value       = scaleway_instance_server.vm.id
}

output "vm_public_ip" {
  description = "Public IP of the VM instance"
  value       = scaleway_instance_ip.vm.address
}