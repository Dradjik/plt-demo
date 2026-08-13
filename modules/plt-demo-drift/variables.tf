variable "scaleway_project_id" {
  description = "Scaleway project ID the drift resources belong to"
  type        = string
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
  default     = "drift-vpc"
}

variable "private_network_name" {
  description = "Name for the VPC private network"
  type        = string
  default     = "drift-private-network"
}

variable "private_network_subnet" {
  description = "IPv4 CIDR for the private network"
  type        = string
  default     = "172.16.32.0/22"
}

variable "security_group_name" {
  description = "Name for the security group"
  type        = string
  default     = "drift-security-group"
}

variable "allowed_inbound_ports" {
  description = "Inbound ports opened by the security group (prime drift target)"
  type        = list(number)
  default     = [22, 443]
}

variable "allowed_inbound_cidr" {
  description = "CIDR allowed by the inbound rules"
  type        = string
  default     = "0.0.0.0/0"
}

variable "placement_group_name" {
  description = "Name for the placement group"
  type        = string
  default     = "drift-placement-group"
}

variable "bucket_name" {
  description = "Name for the drift-test object bucket"
  type        = string
}

variable "bucket_versioning" {
  description = "Whether bucket versioning is enabled (drift target)"
  type        = bool
  default     = false
}

variable "registry_namespace_name" {
  description = "Name for the container registry namespace"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "drift-test"
  }
}
