
data "aws_availability_zones" "all" {}

data "template_file" "user_data" {

  template = "${file("${path.module}/user_data.sh")}"

  vars {
    server_port = "${var.server_port}"
    #db_address = "${data.terraform_remote_state.db.address}"
    #db_address = "${data.terraform_remote_state.db.address}"
  }
}

resource "aws_launch_configuration" "example" {

  image_id = "${var.ami}"
  instance_type = "${var.instance_type}"
  #security_groups = ["${var.security_group_id}"]
  security_groups = ["${aws_security_group.instance.id}"]

  #user_data = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_elb" "example" {

  #name = "terraform-asg-example"
  name = "${var.cluster_name}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  #security_groups = ["${var.security_group_id}"]
  security_groups = ["${aws_security_group.elb.id}"]

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

  min_size = "${var.min_size}"
  max_size = "${var.max_size}"

  tag {
    key = "Name"
    propagate_at_launch = true
    #value = "terraform-asg-example"
    value = "${var.cluster_name}"
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

resource "aws_security_group" "elb" {
  name = "${var.cluster_name}-elb"
}

resource "aws_security_group_rule" "allow_http_inbound" {

  type = "ingress"

  security_group_id = "${aws_security_group.elb.id}"

  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

}

resource "aws_security_group_rule" "allow_all_outbound" {

  type = "egress"

  security_group_id = "${aws_security_group.elb.id}"

  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]

}
