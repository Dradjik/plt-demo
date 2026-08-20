# Credentials. Set via TF_VAR_scaleway_access_key / TF_VAR_scaleway_secret_key —
# the same pair feeds both the scaleway provider and the s3 backend, so there is
# nothing to duplicate.
#
# Deliberately NOT marked sensitive: OpenTofu refuses to init a backend whose
# config references sensitive values ("Backend config contains sensitive values").
# The trade-off is that these land in .terraform/terraform.tfstate and in any
# saved plan file — both gitignored. Don't share plan files.
variable "scaleway_access_key" {
  description = "Scaleway access key (TF_VAR_scaleway_access_key)"
  type        = string
}

variable "scaleway_secret_key" {
  description = "Scaleway secret key (TF_VAR_scaleway_secret_key)"
  type        = string
}

variable "scaleway_zone" {
  description = "Scaleway zone (e.g., fr-par-1)"
  type        = string
  default     = "fr-par-1"
}

variable "scaleway_region" {
  description = "Scaleway region (e.g., fr-par)"
  type        = string
  default     = "fr-par"
}

# The project is created manually in the console (named plt-demo-drift by
# convention) and referenced by ID here. Every resource lands in it.
variable "scaleway_project_id" {
  description = "ID of the existing Scaleway project holding this stack"
  type        = string
  sensitive   = true
}

variable "registry_namespace_name" {
  description = "Name for the registry namespace (generated with a random suffix if empty)"
  type        = string
  default     = ""
}
