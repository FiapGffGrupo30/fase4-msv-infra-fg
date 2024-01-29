output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "ecs_task_definition_requests_arn" {
  value = aws_ecs_task_definition.ecs_task_definition-requests.arn
}

output "ecs_task_definition_payments_arn" {
  value = aws_ecs_task_definition.ecs_task_definition-payments.arn
}

output "ecs_task_definition_users_arn" {
  value = aws_ecs_task_definition.ecs_task_definition-users.arn
}

output "ecs_task_definition_products_arn" {
  value = aws_ecs_task_definition.ecs_task_definition-products.arn
}

output "ecs_service_name_requests" {
  value = aws_ecs_service.ecs_service_requests.name
}

output "ecs_service_name_payments" {
  value = aws_ecs_service.ecs_service_payments.name
}

output "ecs_service_name_users" {
  value = aws_ecs_service.ecs_service_users.name
}

output "ecs_service_name_products" {
  value = aws_ecs_service.ecs_service_products.name
}