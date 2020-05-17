
module "EdgeAccelerator" {
  source = "github.com/packet-labs/EdgeAccelerator"

  packet_auth_token = var.packet_auth_token
  packet_project_id = var.packet_project_id

  origin_url = format("http://[%s]",packet_device.origin.access_public_ipv6)

  edges = [ "sjc1", "dfw2", ]
}
