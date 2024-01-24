resource "aws_vpc" "new-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.prefix}-vpc"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public-subnets" {
  count                   = 2
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.new-vpc.id
  cidr_block              = "10.0.${count.index * 2 + 2}.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix}-subnet-public-${count.index}"
  }
}

resource "aws_subnet" "private-subnets" {
  count                   = 2
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.new-vpc.id
  cidr_block              = "10.0.${count.index * 2 + 1}.0/24"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.prefix}-subnet-private-${count.index}"
  }
}

resource "aws_internet_gateway" "new-igw" {
  vpc_id = aws_vpc.new-vpc.id
  tags = {
    Name = "${var.prefix}-igw"
  }
}

resource "aws_route_table" "rtb-public" {
  vpc_id = aws_vpc.new-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.new-igw.id
  }
  tags = {
    Name = "${var.prefix}-rtb-public"
  }
}

resource "aws_route_table" "rtb-private" {
  vpc_id = aws_vpc.new-vpc.id
  tags = {
    Name = "${var.prefix}-rtb-private"
  }
}

resource "aws_route_table_association" "public-rtb-association" {
  count          = 2
  route_table_id = aws_route_table.rtb-public.id
  subnet_id      = aws_subnet.public-subnets[count.index].id
}

resource "aws_route_table_association" "private-rtb-association" {
  count          = 2
  route_table_id = aws_route_table.rtb-private.id
  subnet_id      = aws_subnet.private-subnets[count.index].id
}