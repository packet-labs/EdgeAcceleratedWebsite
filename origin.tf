provider "packet" {
  auth_token = var.packet_auth_token
}

resource "tls_private_key" "key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "packet_ssh_key" "packet_key" {
  name       = "origin-deployment-key"
  public_key = tls_private_key.key.public_key_openssh
}

resource "packet_device" "origin" {
  depends_on       = [packet_ssh_key.packet_key]

  plan             = "c3.medium.x86"
  project_id       = var.packet_project_id

  operating_system = "ubuntu_18_04"
  billing_cycle    = "hourly"

  facilities       = ["sjc1"]
  hostname         = format("origin")

  # private ipv4 and public ipv6 only - no public ipv4
  ip_address {
    type = "public_ipv6"
    cidr = 127
  }

  ip_address {
    type = "private_ipv4"
    cidr = 31
  }

  connection {
    host        = self.access_public_ipv6
    type        = "ssh"
    user        = "root"
    private_key = tls_private_key.key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get -y update", 
      "apt-get -y install nginx",
    ]
  }
}

