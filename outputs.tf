# Output variable definitions

output "deployed_edge_proxies_ipv4" {
  value = module.EdgeAccelerator.deployed_edge_proxies_ipv4
}

output "deployed_edge_proxies_ipv6" {
  value = module.EdgeAccelerator.deployed_edge_proxies_ipv6
}
