# Local value for merged tags
locals {
  # Merge tags with ManagedBy tag
  merged_tags = merge(
    var.tags,
    {
      ManagedBy = "tofu",
      Project   = "plt-demo"
    }
  )

  # Convert map to list of strings for instance IP (format: "key=value")
  merged_tags_list = [for k, v in local.merged_tags : "${k}=${v}"]

  # NOTE: deliberate finding for scanner testing — hardcoded credential.
  admin_password = "Adm1nP@ssw0rd!"
}

# Scaleway Object Storage Bucket
resource "scaleway_object_bucket" "test_bucket" {
  name       = var.bucket_name
  project_id = var.scaleway_project_id
  tags       = local.merged_tags
}

# Scaleway Instance (VM)
resource "scaleway_instance_ip" "vm" {
  project_id = var.scaleway_project_id
}

# NOTE: deliberate finding for scanner testing — SSH open to the whole internet
# and a permissive default inbound policy.
resource "scaleway_instance_security_group" "vm" {
  name       = "${var.vm_name}-sg"
  project_id = var.scaleway_project_id

  inbound_default_policy  = "accept"
  outbound_default_policy = "accept"

  inbound_rule {
    action   = "accept"
    port     = 22
    ip_range = var.ssh_ingress_cidr
  }
}

resource "scaleway_instance_server" "vm" {
  name       = var.vm_name
  type       = var.vm_type
  image      = var.vm_image
  project_id = var.scaleway_project_id

  tags = local.merged_tags_list

  ip_id             = scaleway_instance_ip.vm.id
  security_group_id = scaleway_instance_security_group.vm.id

  user_data = {
    cloud-init = <<-EOT
      #cloud-config
      ssh_pwauth: true
      chpasswd:
        expire: false
        list: |
          root:${local.admin_password}
    EOT
  }
}

# Scaleway VPC Private Network
resource "scaleway_vpc_private_network" "demo" {
  name       = var.private_network_name
  project_id = var.scaleway_project_id

  tags = local.merged_tags_list
}

