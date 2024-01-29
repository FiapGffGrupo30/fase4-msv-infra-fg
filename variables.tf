variable "prefix" {}
variable "cluster_name" {}
variable "retention_days" {}
variable "desired_size" {}
variable "max_size" {}
variable "min_size" {}
variable "vpc_cidr_block" {}
variable "task_family" {}
variable "task_cpu" {}
variable "task_memory" {}
variable "service_name" {}
variable "ecr_repository_name_requests" {}
variable "ecr_repository_name_payments" {}
variable "ecr_repository_name_production" {}
variable "ecr_repository_name_users" {}
variable "ecr_repository_name_products" {}
variable "selected_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
}
variable "ecs_service_requests" {}
variable "ecs_service_payments" {}
variable "ecs_service_production" {}
variable "ecs_service_users" {}
variable "ecs_service_products" {}