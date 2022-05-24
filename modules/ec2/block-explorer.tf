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
