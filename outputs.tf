#------------------------------------------------------------------------------
# Network
#------------------------------------------------------------------------------
output "network" {
  description = "Network name"
  value       = module.network.network_name
}

output "subnet" {
  description = "Subnet name"
  value       = local.subnet
}

output "vpc_connector_subnet" {
  description = "VPC connector subnet name"
  value       = local.vpc_connector_subnet
}
