provider "aws" {
  region = "eu-west-1"
}

/*data "aws_canonical_user_id" "current" {}*/

/*
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  #owners = ["${data.aws_canonical_user_id.current.id}"] # Canonical
  owners = ["97cc924b777ad0a92d78c0b2dcc196d3552a45783890e2be6ead8f4e77b0c14a"] # Canonical
}
*/

data "aws_availability_zones" "all" {}

resource "aws_launch_configuration" "as_conf" {

  name   = "terraform-lc-example"
  image_id = "ami-0951d4c0729e2f8a9"
  instance_type = "t2.micro"
  security_groups = ["sg-6f59f608"]

  user_data = <<-EOF
!#bin/bash
echo "Hello, world" > index.html
nohup busybox httpd -f -p 8080 &

              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bar" {

  name                 = "terraform-asg-example"

  launch_configuration = "${aws_launch_configuration.as_conf.name}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  min_size = 1
  max_size = 2

  lifecycle {
    create_before_destroy = true
  }
}
