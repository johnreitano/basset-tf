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
  associate_public_ip_address = false

  lifecycle {
    ignore_changes = [associate_public_ip_address]
  }

  tags = {
    Environment = var.env
    Project     = var.project
    Name        = "${var.project}-${var.env}-block-explorer"
  }

}

resource "aws_eip" "block_explorer" {
  vpc = true
  tags = {
    Environment = var.env
    Project     = var.project
    Name        = "${var.project}-${var.env}-block-explorer-eip"
  }
}

resource "aws_eip_association" "block_explorer" {
  depends_on    = [aws_eip.block_explorer]
  instance_id   = aws_instance.block_explorer.id
  allocation_id = aws_eip.block_explorer.id
}

resource "null_resource" "provision_block_explorer" {
  depends_on = [aws_eip_association.block_explorer, aws_instance.block_explorer]

  provisioner "file" {
    source      = "modules/ec2/nginx.sh"
    destination = "/tmp/nginx.sh"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = aws_eip.block_explorer.public_ip
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
      host        = aws_eip.block_explorer.public_ip
    }
  }
}

resource "aws_instance" "seed_1" {
  ami                         = data.aws_ami.latest-ubuntu.id
  instance_type               = "t2.medium"
  subnet_id                   = var.public_subnet_id
  key_name                    = var.ssh_keypair
  vpc_security_group_ids      = [var.public_sg_id]
  associate_public_ip_address = false

  lifecycle {
    ignore_changes = [associate_public_ip_address]
  }

  tags = {
    Environment = var.env
    Project     = var.project
    Name        = "${var.project}-${var.env}-seed-1"
  }

}

resource "aws_eip" "seed_1" {
  vpc = true
  tags = {
    Environment = var.env
    Project     = var.project
    Name        = "${var.project}-${var.env}-seed-eip-1"
  }
}

resource "aws_eip" "seed_2" {
  vpc = true
  tags = {
    Environment = var.env
    Project     = var.project
    Name        = "${var.project}-${var.env}-seed-eip-2"
  }
}

resource "aws_eip" "seed_3" {
  vpc = true
  tags = {
    Environment = var.env
    Project     = var.project
    Name        = "${var.project}-${var.env}-seed-eip-3"
  }
}

resource "aws_eip_association" "seed_1" {
  depends_on    = [aws_eip.seed_1]
  instance_id   = aws_instance.seed_1.id
  allocation_id = aws_eip.seed_1.id

}

# resource "aws_eip_association" "seed_eip_assoc_2" {
#   instance_id   = aws_instance.seed_2.id
#   allocation_id = var.seed_eip_id_2
# }

# resource "aws_eip_association" "seed_eip_assoc_1" {
#   instance_id   = aws_instance.seed_3.id
#   allocation_id = var.seed_eip_id_3
# }

resource "null_resource" "provision_seed_1" {
  depends_on = [aws_eip_association.seed_1, aws_instance.seed_1]

  provisioner "file" {
    source      = "modules/ec2/nginx.sh"
    destination = "/tmp/nginx.sh"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = aws_eip.seed_1.public_ip
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
      host        = aws_eip.seed_1.public_ip
    }
  }
}
