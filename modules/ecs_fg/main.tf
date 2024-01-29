resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

}

resource "aws_ecs_task_definition" "ecs_task_definition-requests" {
  family                   = "${var.task_family}-pedidos"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  container_definitions = jsonencode([
    {
      name  = "gff-task-pedidos",
      image = "nome-da-imagem-do-container-pedidos:tag",
      portMappings = [
        {
          containerPort = 8080,
          hostPort      = 8080,
        },
      ],
    },
  ])
}

resource "aws_ecs_task_definition" "ecs_task_definition-payments" {
  family                   = "${var.task_family}-payments"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  container_definitions = jsonencode([
    {
      name  = "gff-task-pagamentos",
      image = "nome-da-imagem-do-container-pagamentos:tag",
      portMappings = [
        {
          containerPort = 8080,
          hostPort      = 8080,
        },
      ],
    },
  ])
}

resource "aws_ecs_task_definition" "ecs_task_definition-production" {
  family                   = "${var.task_family}-producao"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  container_definitions = jsonencode([
    {
      name  = "gff-task-producao",
      image = "nome-da-imagem-do-container-producao:tag",
      portMappings = [
        {
          containerPort = 8080,
          hostPort      = 8080,
        },
      ],
    },
  ])
}

resource "aws_ecs_task_definition" "ecs_task_definition-users" {
  family                   = "${var.task_family}-usuarios"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  container_definitions = jsonencode([
    {
      name  = "gff-task-usuarios",
      image = "nome-da-imagem-do-container-usuarios:tag",
      portMappings = [
        {
          containerPort = 8080,
          hostPort      = 8080,
        },
      ],
    },
  ])
}

resource "aws_ecs_task_definition" "ecs_task_definition-products" {
  family                   = "${var.task_family}-produtos"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  container_definitions = jsonencode([
    {
      name  = "gff-task-produtos",
      image = "nome-da-imagem-do-container-produtos:tag",
      portMappings = [
        {
          containerPort = 8080,
          hostPort      = 8080,
        },
      ],
    },
  ])
}


resource "aws_ecs_service" "ecs_service_requests" {
  name            = var.ecs_service_requests
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition-requests.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.security_group_id]
  }

  depends_on = [aws_ecs_task_definition.ecs_task_definition-requests]
}

resource "aws_ecs_service" "ecs_service_payments" {
  name            = var.ecs_service_payments
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition-payments.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.security_group_id]
  }

  depends_on = [aws_ecs_task_definition.ecs_task_definition-payments]
}

resource "aws_ecs_service" "ecs_service_production" {
  name            = var.ecs_service_production
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition-production.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.security_group_id]
  }

  depends_on = [aws_ecs_task_definition.ecs_task_definition-production]
}

resource "aws_ecs_service" "ecs_service_users" {
  name            = var.ecs_service_users
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition-users.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.security_group_id]
  }

  depends_on = [aws_ecs_task_definition.ecs_task_definition-users]
}

resource "aws_ecs_service" "ecs_service_products" {
  name            = var.ecs_service_products
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition-products.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.security_group_id]
  }

  depends_on = [aws_ecs_task_definition.ecs_task_definition-products]
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}