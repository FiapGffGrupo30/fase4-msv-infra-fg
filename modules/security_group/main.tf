resource "aws_security_group" "gff-alb-sg" {
  name        = "gff-alb-sg"
  description = "Allows access from internet"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}