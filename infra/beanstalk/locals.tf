locals {
  settings = [{
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_default_vpc.default.id
    }, {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_default_subnet.default_az1.id}, ${aws_default_subnet.default_az1.id}, ${aws_default_subnet.default_az1.id}"
    }, {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.eb.id
    }, {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PGDATABASE"
    value     = "postgres"
    }, {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PGHOST"
    value     = var.postgres_address
    }, {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PGPORT"
    value     = var.postgres_port
    }, {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PGPASSWORD"
    value     = var.db_password
    }, {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PGUSER"
    value     = var.db_user
    }, {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "REDIS_HOST"
    value     = var.redis_address
    }, {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "REDIS_PORT"
    value     = var.redis_port
    }
  ]
}
