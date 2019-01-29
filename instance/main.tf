provider "aws" {
  region = "eu-west-1"
}

variable "server_port" {
  description = "This is the port for the server."
  default = 8080
}

resource "aws_instance" "example" {
  ami = "ami-0286372f78291e588"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, world" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  tags {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance"
{
  name = "terraform-example-instance"

  ingress {
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

}

output "public_ip" {
  value = "${aws_instance.example.private_ip}"
}