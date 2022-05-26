resource "aws_instance" "validator" {
  count                       = 3
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
    Name        = "${var.project}-${var.env}-validator-${count.index}"
  }

}
resource "aws_eip" "validator" {
  count    = 3
  instance = aws_instance.validator[count.index].id
  vpc      = true
  tags = {
    Environment = var.env
    Project     = var.project
    Name        = "${var.project}-${var.env}-validator-eip-${count.index}"
  }
}

resource "null_resource" "setup_instance" {
  count = 2
  # depends_on = [aws_eip.validator[count.index], aws_instance.validator[count.index]]

  provisioner "file" {
    source      = "modules/ec2/setup.sh"
    destination = "/tmp/setup.sh"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = aws_eip.validator[count.index].public_ip
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "sudo /tmp/setup.sh",
      "echo provisioning node ${count.index}"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = aws_eip.validator[count.index].public_ip
    }
  }
}
