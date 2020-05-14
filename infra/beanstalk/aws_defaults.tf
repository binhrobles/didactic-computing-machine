resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "${var.region}a"
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "${var.region}b"
}

resource "aws_default_subnet" "default_az3" {
  availability_zone = "${var.region}c"
}
