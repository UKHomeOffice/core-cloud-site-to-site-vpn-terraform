################################
# Common Tags
################################
variable "tags" {
  description = "Common tags to apply to created resources."
  type        = map(string)
}

################################
# Target VPC (looked up in data.tf)
################################
variable "vpc_name" {
  description = "The Name tag of the target VPC (used by data.tf to look up the VPC)."
  type        = string
}

################################
# Environment type (for naming)
################################
variable "environment_type" {
  description = "Environment label for names/tags (e.g., dev, test, prod, tenant specific naming)."
  type        = string
}

################################
# Customer Gateway IP
################################
variable "customer_gateway_ipaddress" {
  description = "Public IPv4 address of the on-prem/customer VPN device."
  type        = string

  validation {
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\\.|$)){4}$", var.customer_gateway_ipaddress))
    error_message = "customer_gateway_ipaddress must be a valid IPv4 address."
  }
}

################################
# VPN static routes (one or many)
################################
variable "vpn_static_route_cidrs" {
  description = "List of destination CIDRs to add as static routes on the VPN connection."
  type        = list(string)

  validation {
    condition     = alltrue([for c in var.vpn_static_route_cidrs : can(cidrnetmask(c))])
    error_message = "vpn_static_route_cidrs must contain only valid CIDR blocks."
  }
}

################################
# Private route tables (from private_subnets outputs)
################################
variable "private_route_table_ids" {
  description = "List of private route table IDs to which VGW routes will be added."
  type        = list(string)

  validation {
    condition     = length(var.private_route_table_ids) > 0
    error_message = "private_route_table_ids must contain at least one route table ID."
  }
}

################################
# Destinations for VGW routes
################################
variable "destination_cidr_blocks" {
  description = "List of destination CIDRs to route via the VGW."
  type        = list(string)

  validation {
    condition     = alltrue([for c in var.destination_cidr_blocks : can(cidrnetmask(c))])
    error_message = "destination_cidr_blocks must contain only valid CIDR blocks."
  }
}

################################
# firsvpn_secret_id
################################
variable "firsvpn_secret_id" {
  type        = string
  description = "ARN or name of Secrets Manager secret containing tunnel PSKs"
}