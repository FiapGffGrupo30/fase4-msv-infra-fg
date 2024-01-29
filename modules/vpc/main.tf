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
//resource "aws_subnet" "private-subnet-1" {
//  count                   = 1
//  availability_zone       = data.aws_availability_zones.available.names[count.index]
//  vpc_id                  = aws_vpc.new-vpc.id
//  cidr_block              = "10.0.${count.index * 2 + 1}.0/24"
//  map_public_ip_on_launch = false
//  tags = {
//    Name = "${var.prefix}-subnet-private-1"
//  }
//}
//resource "aws_subnet" "private-subnet-2" {
//  count                   = 1
//  availability_zone       = data.aws_availability_zones.available.names[count.index]
//  vpc_id                  = aws_vpc.new-vpc.id
//  cidr_block              = "10.0.${count.index * 2 + 3}.0/24"
//  map_public_ip_on_launch = false
//  tags = {
//    Name = "${var.prefix}-subnet-private-2"
//  }
//}

resource "aws_internet_gateway" "new-igw" {
  vpc_id = aws_vpc.new-vpc.id
  tags = {
    Name = "${var.prefix}-igw"
  }
}

resource "aws_route_table" "new-rtb" {
  vpc_id = aws_vpc.new-vpc.id
  tags = {
    Name = "${var.prefix}-rtb"
  }
}

resource "aws_route_table_association" "public-rtb-association" {
  count          = length(aws_subnet.public-subnets)
  subnet_id      = aws_subnet.public-subnets[count.index].id
  route_table_id = aws_route_table.new-rtb.id
}

//resource "aws_route_table_association" "private-rtb-association-1" {
//  count          = length(aws_subnet.private-subnet-1)
//  subnet_id      = aws_subnet.private-subnet-1[count.index].id
//  route_table_id = aws_route_table.new-rtb.id
//}
//
//resource "aws_route_table_association" "private-rtb-association-2" {
//  count          = length(aws_subnet.private-subnet-2)
//  subnet_id      = aws_subnet.private-subnet-2[count.index].id
//  route_table_id = aws_route_table.new-rtb.id
//}