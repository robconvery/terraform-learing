provider "aws" {
  region = "eu-west-1"
}

module "cluster" {
  source = "../../../../modules/services/cluster"
  cluster_name = "terraform-stage"
  instance_type = "t2.micro"
  min_size = 2
  max_size = 10
}

output "elb_dns_name" {
  value = "${module.cluster.elb_dns_name}"
}
