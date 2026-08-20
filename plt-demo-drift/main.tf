terraform {
  # >= 1.8 for early variable evaluation — the backend block below reads var.*
  # (OpenTofu only; Terraform cannot parse this configuration)
  required_version = ">= 1.8"

  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    endpoint                    = "s3.fr-par.scw.cloud"
    bucket                      = "plt-demo-drift-tf"
    key                         = "plt-demo-drift/terraform.tfstate"
    region                      = "fr-par"
    access_key                  = var.scaleway_access_key
    secret_key                  = var.scaleway_secret_key
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    use_path_style              = true
  }
}

provider "scaleway" {
  access_key = var.scaleway_access_key
  secret_key = var.scaleway_secret_key
  zone       = var.scaleway_zone
  region     = var.scaleway_region
  project_id = var.scaleway_project_id
}

# Globally-unique names for the bucket and registry namespace
resource "random_pet" "suffix" {
  length = 2
}

locals {
  # Bucket names are globally unique across Scaleway — always randomize, never
  # let a tfvars value pin it to a name someone else may already hold.
  bucket_name   = "plt-demo-drift-${random_pet.suffix.id}"
  registry_name = var.registry_namespace_name != "" ? var.registry_namespace_name : "plt-demo-drift-${random_pet.suffix.id}"
}

module "drift" {
  source = "../modules/plt-demo-drift"

  scaleway_project_id     = var.scaleway_project_id
  bucket_name             = local.bucket_name
  registry_namespace_name = local.registry_name

  tags = {
    Environment = "drift-test"
  }
}
