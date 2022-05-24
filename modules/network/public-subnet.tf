resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"

  tags = {
    Environment = var.env
    Project     = var.project
    Name        = "${var.project}-${var.env}-public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Environment = var.env
    Project     = var.project
    Name        = "${var.project}-${var.env}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Environment = var.env
    Project     = var.project
    Name        = "${var.project}-${var.env}-public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# resource "aws_nat_gateway" "nat_gw" {
#   allocation_id = aws_eip.eip_for_nat.id
#   subnet_id     = aws_subnet.public.id

#   tags = {
#     Environment = var.env
#     Project     = var.project
#     Name        = "${var.project}-${var.env}-nat-gw"
#   }
# }

# resource "aws_route_table" "nat_route_table" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.nat_gw.id
#   }

#   tags = {
#     Environment = var.env
#     Project     = var.project
#     Name        = "${var.project}-${var.env}-nat-route-table"
#   }
# }

resource "aws_security_group" "public" {
  name        = "${var.env}-public-sg"
  description = "SG to alllow traffic from the public seed nodes and web server"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Ping"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Environment = var.env
    Project     = var.project
    Name        = "${var.project}-${var.env}-public-sg"
  }
}

