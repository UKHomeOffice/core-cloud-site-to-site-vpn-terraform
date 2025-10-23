################################
# Variables
################################

################################
# Target VPC (looked up in data.tf)
################################
variable "vpc_name" {
  description = "The Name tag of the target VPC (used in data.tf to look up the VPC)."
  type        = string
}

################################
# Private Subnet CIDRs (explicit list)
################################
variable "private_subnet_cidrs" {
  description = "Exact CIDRs for private subnets (e.g., [\"10.111.244.64/26\", \"10.111.244.128/26\", \"10.111.244.192/26\"])."
  type        = list(string)

  # Validate shape and uniqueness
  validation {
    condition     = alltrue([for c in var.private_subnet_cidrs : can(cidrnetmask(c))])
    error_message = "Each entry in private_subnet_cidrs must be a valid CIDR."
  }

  validation {
    condition     = length(var.private_subnet_cidrs) == length(distinct(var.private_subnet_cidrs))
    error_message = "private_subnet_cidrs contains duplicates; subnets must be unique."
  }
}

################################
# Transit Gateway
################################
variable "tgw_id" {
  description = "Transit Gateway ID used for the 0.0.0.0/0 route in each private route table."
  type        = string
}

################################
# Common Tags
################################
variable "tags" {
  description = "Common tags to apply to created resources."
  type        = map(string)
}
