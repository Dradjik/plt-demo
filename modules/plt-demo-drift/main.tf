# Drift-testing module: free Scaleway resources only.
# Every resource here is a deliberate drift target — change it in the console,
# then `tofu plan -detailed-exitcode` should report it.

locals {
  merged_tags = merge(
    var.tags,
    {
      ManagedBy = "tofu"
      Project   = "plt-demo-drift"
    }
  )

  # Instance-scoped resources take tags as a "key=value" list
  merged_tags_list = [for k, v in local.merged_tags : "${k}=${v}"]
}

# --- Network (free) -------------------------------------------------------
# Drift targets: name, tags, ipv4_subnet
resource "scaleway_vpc" "demo" {
  name       = var.vpc_name
  project_id = var.scaleway_project_id
  tags       = local.merged_tags_list
}

resource "scaleway_vpc_private_network" "demo" {
  name       = var.private_network_name
  project_id = var.scaleway_project_id
  vpc_id     = scaleway_vpc.demo.id
  tags       = local.merged_tags_list

  ipv4_subnet {
    subnet = var.private_network_subnet
  }
}

# --- Security group (free) ------------------------------------------------
# Best drift target: open a port in the console and plan will flag the rule.
resource "scaleway_instance_security_group" "demo" {
  name                    = var.security_group_name
  description             = "Drift-test security group"
  project_id              = var.scaleway_project_id
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"
  tags                    = local.merged_tags_list

  dynamic "inbound_rule" {
    for_each = var.allowed_inbound_ports
    content {
      action = "accept"
      port   = inbound_rule.value
      # ip_range, not ip: `ip` is deprecated and only accepts a single address
      ip_range = var.allowed_inbound_cidr
    }
  }
}

# --- Placement group (free) -----------------------------------------------
# Drift targets: name, tags, policy_type (low_latency/max_availability)
resource "scaleway_instance_placement_group" "demo" {
  name        = var.placement_group_name
  project_id  = var.scaleway_project_id
  policy_type = "max_availability"
  tags        = local.merged_tags_list
}

# --- Object bucket (free tier) --------------------------------------------
# Drift targets: tags, versioning
resource "scaleway_object_bucket" "demo" {
  name       = var.bucket_name
  project_id = var.scaleway_project_id
  tags       = local.merged_tags

  versioning {
    enabled = var.bucket_versioning
  }
}

# --- Container registry namespace (free) ----------------------------------
# Drift targets: description, is_public
resource "scaleway_registry_namespace" "demo" {
  name        = var.registry_namespace_name
  description = "Drift-test registry namespace"
  project_id  = var.scaleway_project_id
  is_public   = false
}
