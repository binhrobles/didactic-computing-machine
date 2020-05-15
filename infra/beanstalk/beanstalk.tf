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

  dynamic "setting" {
    for_each = local.settings
    content {
      namespace = setting.value["namespace"]
      name      = setting.value["name"]
      value     = setting.value["value"]
    }
  }
}
