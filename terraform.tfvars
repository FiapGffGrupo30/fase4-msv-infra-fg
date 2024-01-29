prefix                         = "soat2-grupo-30"
cluster_name                   = "cluster-gff"
retention_days                 = 1
desired_size                   = 2
max_size                       = 4
min_size                       = 2
vpc_cidr_block                 = "10.0.0.0/16"
task_family                    = "gff-task-definition"
task_cpu                       = "256"
task_memory                    = "512"
service_name                   = "test"
ecr_repository_name_requests   = "gff-repository-pedidos"
ecr_repository_name_payments   = "gff-repository-pagamentos"
ecr_repository_name_users      = "gff-repository-usuarios"
ecr_repository_name_products   = "gff-repository-produtos"
ecs_service_requests           = "service-pedidos"
ecs_service_payments           = "service-pagamentos"
ecs_service_users              = "service-usuarios"
ecs_service_products           = "service-produtos"