resource "aws_instance" "validator_1" {
  ami                         = data.aws_ami.latest-ubuntu.id
  instance_type               = "t2.medium"
  subnet_id                   = var.validator_subnet_id
  key_name                    = var.ssh_keypair
  vpc_security_group_ids      = [var.validator_sg_id]
  associate_public_ip_address = false

  lifecycle {
    ignore_changes = [associate_public_ip_address]
  }

  tags = {
    Environment = var.env
    Project     = var.project
    Name        = "${var.project}-${var.env}-validator-1"
  }

}

resource "aws_eip" "validator_1" {
  vpc = true
  tags = {
    Environment = var.env
    Project     = var.project
    Name        = "${var.project}-${var.env}-validator-1-eip"
  }
}

resource "aws_eip_association" "validator_1" {
  depends_on    = [aws_eip.validator_1]
  instance_id   = aws_instance.validator_1.id
  allocation_id = aws_eip.validator_1.id
}

resource "null_resource" "provision_validator_1" {
  depends_on = [aws_eip_association.validator_1, aws_instance.validator_1]

  provisioner "file" {
    source      = "modules/ec2/nginx.sh"
    destination = "/tmp/nginx.sh"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = aws_eip.validator_1.public_ip
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
      host        = aws_eip.validator_1.public_ip
    }
  }
}

