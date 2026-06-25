# Local value for merged tags
locals {
  # Merge tags with ManagedBy tag
  merged_tags = merge(
    var.tags,
    {
      ManagedBy = "tofu", 
      Project = "plt-demo"
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

# Scaleway Instance (VM)
resource "scaleway_instance_ip" "vm" {
  project_id = var.scaleway_project_id
}

resource "scaleway_instance_server" "vm" {
  name       = var.vm_name
  type       = var.vm_type
  image      = var.vm_image
  project_id = var.scaleway_project_id

  tags = local.merged_tags_list

  ip_id = scaleway_instance_ip.vm.id
}

# Scaleway VPC Private Network
resource "scaleway_vpc_private_network" "demo" {
  name       = var.private_network_name
  project_id = var.scaleway_project_id

  tags = local.merged_tags_list
}

