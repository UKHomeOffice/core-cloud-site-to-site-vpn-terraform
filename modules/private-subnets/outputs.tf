locals {
  rtb_by_name = {
    for k, rt in aws_route_table.private :
    aws_route_table.private[k].tags["Name"] => rt.id
  }
}

output "private_route_table_ids_by_name" {
  value = local.rtb_by_name
}

output "private_route_table_ids" {
  description = "Route table IDs for private subnets (sorted by name)"
  value       = [for name in sort(keys(local.rtb_by_name)) : local.rtb_by_name[name]]
}
