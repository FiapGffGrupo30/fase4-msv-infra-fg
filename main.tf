terraform {
  required_version = ">=0.13.1"
  required_providers {
    aws   = ">=5.22.0"
    local = ">=2.4.0"
  }
  # Salvando o tfstate no Bucket S3 para evitarmos quebrar
  # o tfstate ao trabalharmos em grupos/squads.
  # OBS 1: Se faz necessário criar o Buckt S3 antes de executar
  # esse trechode código.
  # OBS 2: Ao criar o S3 deixar abilitado o auto versionamento a
  # cada alteração.
  //backend "s3" {
  //  bucket = "bucket-cluster-gff"
  //  key    = "terraform.tfstate"
  //  region = "us-east-1"
  //}
}

provider "aws" {
  region = "us-east-1"
}

module "new-vpc" {
  source         = "./modules/vpc"
  prefix         = var.prefix
  vpc_cidr_block = var.vpc_cidr_block
}

module "security-group" {
  source = "./modules/security_group"
  vpc_id = module.new-vpc.vpc_id
}

module "target-group" {
  source = "./modules/target_group"
  vpc_id = module.new-vpc.vpc_id
}

module "load_balance" {
  source            = "./modules/load_balance"
  vpc_id            = module.new-vpc.vpc_id
  security_group_id = module.security-group.security_group_id
  public_subnet_ids = module.new-vpc.public_subnet_ids
}

module "ecs_fargate" {
  source            = "./modules/ecs_fg"
  subnets           = module.new-vpc.private_subnet_ids
  security_group_id = module.security-group.security_group_id
  task_family       = var.task_family
  task_cpu          = var.task_cpu
  task_memory       = var.task_memory
  cluster_name      = var.cluster_name
  service_name      = var.service_name
}

module "ecr_repository" {
  source = "./modules/ecr"
  ecr_repository_name = var.ecr_repository_name
}