resource "aws_subnet" "db" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.db_subnet_cidr
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2a"

  tags = {
    Environment = var.env
    Project     = var.project
    Name        = "${var.project}-${var.env}-db-subnet"
  }
}

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Environment = var.env
    Project     = var.project
    Name        = "${var.project}-${var.env}-db-route-table"
  }
}

resource "aws_route_table_association" "db" {
  subnet_id      = aws_subnet.db.id
  route_table_id = aws_route_table.db.id
}

resource "aws_security_group" "db" {
  name        = "${var.env}-db-sg"
  description = "SG to alllow traffic from the rds db"
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
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["68.101.219.8/32"]
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id]
  }

  tags = {
    Environment = var.env
    Project     = var.project
    Name        = "${var.project}-${var.env}-db-sg"
  }
}
