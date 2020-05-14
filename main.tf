terraform {
  backend "remote" {
    organization = "binhrobles"

    workspaces {
      name = "didactic-computing-machine"
    }
  }
}

provider "aws" {
  region = var.region
}

module "eb" {
  source                = "./infra/beanstalk"
  app_env_name          = var.app_env_name
  region                = var.region
  db_user               = var.db_user
  db_password           = var.db_password
  postgres_domain       = module.postgres.domain
  postgres_port         = module.postgres.port
  redis_cluster_address = module.redis.cluster_address
  redis_port            = module.redis.port
}

module "postgres" {
  source      = "./infra/postgres"
  db_user     = var.db_user
  db_password = var.db_password
  eb_sg_id    = module.eb.sg_id
}

module "redis" {
  source   = "./infra/redis"
  eb_sg_id = module.eb.sg_id
}
