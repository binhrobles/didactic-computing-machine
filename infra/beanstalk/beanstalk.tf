/* Github Action will take care of creating S3 bucket/EB version and deploying */
/* https://github.com/einaregilsson/beanstalk-deploy */

resource "aws_security_group" "eb" {
  name_prefix = "eb"
  description = "Facilitates communication b/w EB, Elasticache, and RDS"
}

resource "aws_elastic_beanstalk_application" "didactic-eb" {
  name = "didactic-computing-machine"
}

resource "aws_elastic_beanstalk_environment" "didactic-eb-env" {
  name                = var.app_env_name
  application         = aws_elastic_beanstalk_application.didactic-eb.name
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.20.2 running Multi-container Docker 19.03.6-ce (Generic)"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_default_vpc.default.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_default_subnet.default_az1.id}, ${aws_default_subnet.default_az1.id}, ${aws_default_subnet.default_az1.id}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.eb.id
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PGDATABASE"
    value     = "postgres"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PGHOST"
    value     = var.postgres_address
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PGPORT"
    value     = var.postgres_port
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PGPASSWORD"
    value     = var.db_password
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PGUSER"
    value     = var.db_user
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "REDIS_HOST"
    value     = var.redis_cluster_address
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "REDIS_PORT"
    value     = var.redis_port
  }
}
