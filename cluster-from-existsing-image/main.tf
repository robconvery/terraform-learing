provider "aws" {
  region = "eu-west-1"
}

variable "server_port" {
  description = "This is the port for the server."
  default = 80
}

variable "ami" {
  description = "ami of the resource."
  default = "ami-0e101c2ad1fbe6036"
}

variable "security_group_id" {
  description = "Existing security group to be used."
  default = "sg-05fdb3e471325ce6a"
}

data "aws_availability_zones" "all" {}

resource "aws_launch_configuration" "example" {

  image_id = "${var.ami}"
  instance_type = "t2.micro"
  security_groups = ["${var.security_group_id}"]

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_elb" "example" {

  name = "terraform-asg-example"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups = ["${var.security_group_id}"]

  listener {
    instance_port = "${var.server_port}"
    instance_protocol = "http"
    lb_port = "${var.server_port}"
    lb_protocol = "http"
  }

  health_check {
    unhealthy_threshold = 2
    healthy_threshold = 2
    interval = 30
    target = "HTTP:${var.server_port}/"
    timeout = 3
  }
}

resource "aws_autoscaling_group" "example" {

  launch_configuration = "${aws_launch_configuration.example.id}"

  availability_zones = ["${data.aws_availability_zones.all.names}"]

  load_balancers = ["${aws_elb.example.id}"]

  health_check_type = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key = "Name"
    propagate_at_launch = true
    value = "terraform-asg-example"
  }

}

output "elb_dns_name" {
  value = "${aws_elb.example.dns_name}"
}
