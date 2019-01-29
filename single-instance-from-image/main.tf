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

resource "aws_instance" "example" {

  ami = "${var.ami}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${var.security_group_id}"]

  tags {
    Name = "Test using existing ami and sg"
  }
}

