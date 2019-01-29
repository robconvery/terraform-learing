provider "aws" {
  region = "eu-west-1"
}

variable "server_port" {
  description = "This is the port for the server."
  default = 8080
}

data "aws_availability_zones" "all" {}

resource "aws_launch_configuration" "example" {

  image_id = "ami-0286372f78291e588"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.instance.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, world" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "instance" {

  name = "terraform-example-instance"

  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }


}

resource "aws_autoscaling_group" "example" {

  launch_configuration = "${aws_launch_configuration.example.id}"

  availability_zones = ["${data.aws_availability_zones.all.names}"]

  load_balancers = ["${aws_elb.example.name}"]

  health_check_type = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key = "Name"
    propagate_at_launch = true
    value = "terraform-asg-example"
  }
}

resource "aws_elb" "example" {

  name = "terraform-asg-example"

  availability_zones = ["${data.aws_availability_zones.all.names}"]

  security_groups = ["${aws_security_group.elb.id}"]

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.server_port}"
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    interval = 30
    target = "HTTP:${var.server_port}/"
    timeout = 3
    unhealthy_threshold = 2
  }
}

resource "aws_security_group" "elb" {

  name = "terraform-example-elb"

  ingress {
    to_port = 80
    from_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "elb_dns_name" {
  value = "${aws_elb.example.dns_name}"
}
