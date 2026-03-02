output "bucket_name" {
  description = "Name of the created bucket"
  value       = module.plt_demo.bucket_name
}

output "bucket_endpoint" {
  description = "Endpoint of the created bucket"
  value       = module.plt_demo.bucket_endpoint
}

