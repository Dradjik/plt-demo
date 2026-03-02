# Local value for merged tags
locals {
  # Merge tags with ManagedBy tag
  merged_tags = merge(
    var.tags,
    {
      ManagedBy = "tofu"
    }
  )
  
  # Convert map to list of strings for instance IP (format: "key=value")
  merged_tags_list = [for k, v in local.merged_tags : "${k}=${v}"]
}

# Scaleway Object Storage Bucket
resource "scaleway_object_bucket" "test_bucket" {
  name = var.bucket_name
  tags = local.merged_tags
}

# Scaleway Instance IP
resource "scaleway_instance_ip" "test_ip" {
  zone      = var.scaleway_zone
  project_id = var.scaleway_project_id
  tags      = local.merged_tags_list
}

