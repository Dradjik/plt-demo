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

variable "vm_name" {
  description = "Name for the VM instance"
  type        = string
  default     = "demo-vm"
}

variable "vm_type" {
  description = "Instance type (e.g., STARDUST1-S, DEV1-S, GP1-S)"
  type        = string
  default     = "STARDUST1-S"
}

variable "vm_image" {
  description = "Image to use for the VM (e.g., ubuntu_jammy)"
  type        = string
  default     = "ubuntu_jammy"
}

variable "private_network_name" {
  description = "Name for the VPC private network"
  type        = string
  default     = "demo-private-network"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "test"
    ManagedBy   = "tofu"
  }
}

variable "ssh_ingress_cidr" {
  description = "CIDR allowed to reach the VM over SSH"
  type        = string
  default     = "0.0.0.0/0"
}
