data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "block_explorer" {
  ami                         = data.aws_ami.latest-ubuntu.id
  instance_type               = "t2.medium"
  subnet_id                   = var.public_subnet_id
  key_name                    = var.ssh_keypair
  vpc_security_group_ids      = [var.public_sg_id]
  associate_public_ip_address = true // ???
  provisioner "file" {
    source      = "modules/ec2/nginx.sh"
    destination = "/tmp/nginx.sh"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/nginx.sh",
      "sudo /tmp/nginx.sh"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }

  tags = {
    Environment = var.env
    Project     = var.project
    Name        = "${var.project}-${var.env}-block-explorer"
  }

}
