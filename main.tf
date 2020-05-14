terraform {
  backend "remote" {
    organization = "binhrobles"

    workspaces {
      name = "didactic-computing-machine"
    }
  }
}

provider "aws" {
  region  = var.region
}

/* ----- EB resources ----- */
resource "aws_security_group" "sg-eb_common" {
  name        = "sg-eb_common"
  description = "Facilitates communication b/w EB, Elasticache, and RDS"
}

resource "aws_elastic_beanstalk_application" "didactic-eb" {
  name = "didactic-computing-machine"
}

/* Github Action will take care of creating S3 bucket/EB version and deploying */
/* https://github.com/einaregilsson/beanstalk-deploy */

/* ----- Elasticache resources ----- */
resource "aws_security_group" "sg-elasticache" {
  name        = "sg-elasticache"
  description = "Elasticache security group"

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.sg-eb_common.name]
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id         = "didactic-redis"
  engine             = "redis"
  node_type          = "cache.t2.micro"
  num_cache_nodes    = 1
  security_group_ids = [aws_security_group.sg-eb_common.id]
}

/* ----- RDS resources ----- */
resource "aws_db_instance" "postgres" {
  allocated_storage = 20
  instance_class    = "db.t2.micro"
  engine            = "postgres"
  username          = var.db_user
  password          = var.db_password
}

resource "aws_security_group" "sg-postgres" {
  name        = "sg-postgres"
  description = "Postgres security group"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.sg-eb_common.name]
  }
}
