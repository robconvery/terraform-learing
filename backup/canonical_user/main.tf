provider "aws" {
  region = "eu-west-1"
}

data "aws_canonical_user_id" "current" {}

output "canonical_user_id" {
  value = "${data.aws_canonical_user_id.current.id}"
}