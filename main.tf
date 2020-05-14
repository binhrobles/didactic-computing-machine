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

/* ----- EB resources ----- */
resource "aws_security_group" "eb" {
  name_prefix = "eb"
  description = "Facilitates communication b/w EB, Elasticache, and RDS"
}

resource "aws_elastic_beanstalk_application" "didactic-eb" {
  name = "didactic-computing-machine"
}

resource "aws_elastic_beanstalk_environment" "didactic-eb-env" {
  name                = "DidacticComputingMachine-env-1"
  application         = aws_elastic_beanstalk_application.didactic-eb.name
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.20.2 running Multi-container Docker 19.03.6-ce (Generic)"
}

/* Github Action will take care of creating S3 bucket/EB version and deploying */
/* https://github.com/einaregilsson/beanstalk-deploy */

/* ----- Elasticache resources ----- */
resource "aws_security_group" "elasticache" {
  name_prefix = "elasticache"
  description = "Elasticache security group"

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.eb.id]
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id         = "didactic-redis"
  engine             = "redis"
  node_type          = "cache.t2.micro"
  num_cache_nodes    = 1
  security_group_ids = [aws_security_group.eb.id]
}

/* ----- RDS resources ----- */
resource "aws_db_instance" "postgres" {
  allocated_storage = 20
  instance_class    = "db.t2.micro"
  engine            = "postgres"
  username          = var.db_user
  password          = var.db_password
}

resource "aws_security_group" "postgres" {
  name_prefix = "postgres"
  description = "Postgres security group"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.eb.id]
  }
}
