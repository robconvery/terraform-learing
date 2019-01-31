provider "aws" {
  region = "eu-west-1"
}

resource "aws_db_instance" "db" {

  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  name                = "terraform_learning_db"
  engine              = "mysql"
  engine_version      = "5.7"
  password            = "${var.db_password}"
  username            = "root"

}
