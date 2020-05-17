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

# listen only on IPv6
data "template_file" "static-ipv6-website-conf" {

  template =<<EOT
server {
    listen [::]:80;

    root /var/www/static-ipv6-website/;
    index index.html;

    location / {
      try_files $uri $uri/ =404;
    }
}
EOT
}

data "template_file" "static-ipv6-website" {

  template =<<EOT
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>Hello, Edge Accelerator User!</title>
</head>
<body>
    <h1>Hello, Edge Accelerator User!</h1>
    <p>This is a sample website to illustrate pulling content from edge accelerators/reverse proxies.<p>
</body>
</html>
EOT

  vars = {
  }
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
      "unlink /etc/nginx/sites-enabled/default",
      "mkdir -p /var/www/static-ipv6-website/",
    ]
  }

  provisioner "file" {
    content     = data.template_file.static-ipv6-website-conf.rendered
    destination = "/etc/nginx/sites-enabled/static-ipv6-website.conf"
  }

  provisioner "file" {
    content     = data.template_file.static-ipv6-website.rendered
    destination = "/var/www/static-ipv6-website/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "service nginx restart",
    ]
  }
}
