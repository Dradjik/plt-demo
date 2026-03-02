output "bucket_name" {
  description = "Name of the created bucket"
  value       = scaleway_object_bucket.test_bucket.name
}

output "bucket_endpoint" {
  description = "Endpoint of the created bucket"
  value       = scaleway_object_bucket.test_bucket.endpoint
}