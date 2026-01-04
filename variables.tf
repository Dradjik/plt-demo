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

variable "scaleway_project_id" {
  description = "Scaleway project ID"
  type        = string
  sensitive   = true
}

variable "bucket_name" {
  description = "Name for the test bucket (if not provided, will be generated with random suffix)"
  type        = string
  default     = ""
}

