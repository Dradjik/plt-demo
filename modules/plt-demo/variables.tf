variable "scaleway_zone" {
  description = "Scaleway zone (e.g., fr-par-1)"
  type        = string
}

variable "scaleway_project_id" {
  description = "Scaleway project ID (required for instance resources)"
  type        = string
}

variable "bucket_name" {
  description = "Name for the test bucket"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "test"
  }
}