output "bucket_name" {
  description = "Name of the created bucket"
  value       = module.plt_demo.bucket_name
}

output "bucket_endpoint" {
  description = "Endpoint of the created bucket"
  value       = module.plt_demo.bucket_endpoint
}

output "instance_ip_id" {
  description = "ID of the created instance IP"
  value       = module.plt_demo.instance_ip_id
}

output "instance_ip_address" {
  description = "IP address of the created instance IP"
  value       = module.plt_demo.instance_ip_address
}

