output "vpc_id" {
  value = aws_vpc.new-vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public-subnets[*].id
}

//output "private_subnet_ids" {
//  value = concat(aws_subnet.private-subnet-1[*].id, aws_subnet.private-subnet-2[*].id)
//}

//output "internet_gateway_id" {
//  value = aws_internet_gateway.new-igw.id
//}

//output "public_route_table_id" {
//  value = aws_route_table.rtb-public.id
//}

//output "private_route_table_ids" {
//  value = [
//    aws_route_table.rtb-private-1.id,
//    aws_route_table.rtb-private-2.id
//  ]
//}

//output "public_nat_gateway_ids" {
//  value = aws_nat_gateway.public_nat_gateway[*].id
//}

//output "public_eip_ids" {
//  value = aws_eip.public_eips[*].id
//}
