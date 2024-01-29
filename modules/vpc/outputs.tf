output "vpc_id" {
  value = aws_vpc.new-vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public-subnets[*].id
}