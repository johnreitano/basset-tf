resource "aws_subnet" "validator" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.validator_subnet_cidr
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2a"

  tags = {
    Environment = var.env
    Project     = var.project
    Name        = "${var.project}-${var.env}-validator-subnet"
  }
}

resource "aws_route_table_association" "validator_nat_gw_assoc" {
  subnet_id      = aws_subnet.validator.id
  route_table_id = aws_route_table.nat_gw.id
}

resource "aws_security_group" "validator" {
  name        = "${var.env}-validator-sg"
  description = "SG to alllow traffic from the validator clients"
  vpc_id      = aws_vpc.vpc.id
  depends_on = [
    aws_vpc.vpc
  ]

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["68.101.219.8/32"]
  }

  ingress {
    from_port   = 1317
    to_port     = 1317
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 26656
    to_port     = 26656
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 26657
    to_port     = 26657
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.env
    Project     = var.project
    Name        = "${var.project}-${var.env}-validator-sg"
  }
}

