data "aws_ami" "ubuntu" {

    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}


module "paulonunes-12dvp" {
  source = "terraform-aws-modules/ec2-instance/aws"

#  count = 1

  name                        = "${var.name}-${var.environments}"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_pair
  monitoring                  = true
#  vpc_security_group_ids      = [module.security_group_bastion.security_group_id]
#  subnet_id                   = element(module.vpc.public_subnets, 0)
  associate_public_ip_address = true
  tags                        = var.default_tags

  user_data = <<EOF
#!/bin/bash
# Sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done
echo "Set Sao Paulo timezone"
timedatectl set-timezone America/Sao_Paulo
echo "Installing NodeExporter"
mkdir /home/ubuntu/node_exporter
cd /home/ubuntu/node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-amd64.tar.gz
tar node_exporter-1.2.2.linux-amd64.tar.gz
cd node_exporter-1.2.2.linux-amd64
./node_exporter &
echo "Update and upgrade the system"
apt update -y && apt upgrade -y
# Install Rancher
apt install -y docker.io
docker version
usermod -aG docker $USER
newgrp docker
systemctl start docker
systemctl enable docker
docker run -d --name=rancher-server --restart=unless-stopped -p 80:80 -p 443:443 --privileged rancher/rancher:v2.4.18
docker ps
sysctl -p
EOF

  root_block_device = [
    {
      encrypted             = true
      delete_on_termination = true
      volume_type           = "${var.ebs_root_type}"
      volume_size           = "${var.ebs_root_size_in_gb}"
    },
  ]

}

resource "aws_eip" "eip" {
#  count = 2
  vpc   = true
  tags = {
    Name = "${var.name}-${var.environments}"
  }
}

//// EIP Association Bastion 1

resource "aws_eip_association" "eip_assoc" {
#  count         = 2
  instance_id   = module.paulonunes-12dvp.id
  allocation_id = aws_eip.eip.id
}
