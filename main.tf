terraform {
  required_version = ">= 1.0"

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
    bucket                      = "plt-demo-tf"
    key                         = "terraform.tfstate"
    region                      = "fr-par"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    use_path_style = true
  }
}

provider "scaleway" {
  zone       = var.scaleway_zone
  region     = var.scaleway_region
  project_id = var.scaleway_project_id
}

# Random pet name for unique bucket naming
resource "random_pet" "random" {
  length = 2
}

# Local value to generate bucket name if not provided
locals {
  bucket_name = var.bucket_name != "" ? var.bucket_name : "tofu-test-bucket-${random_pet.random.id}"
}

# Call the plt-demo module
module "plt_demo" {
  source = "./modules/plt-demo"

  scaleway_zone = var.scaleway_zone
  bucket_name   = local.bucket_name
  tags = {
    Environment = "test"
  }
}

