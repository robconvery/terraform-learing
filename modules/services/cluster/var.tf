variable "server_port" {
  description = "This is the port for the server."
  default = 80
}

# has nginx preinstalled.
variable "ami" {
  description = "ami of the resource."
  default = "ami-0e101c2ad1fbe6036"
}

# trying to phase out.
variable "security_group_id" {
  description = "Existing security group to be used."
  default = "sg-05fdb3e471325ce6a"
}

variable "cluster_name" {
  description = "The name of the cluster."
}

variable "instance_type" {
  description = "The type of EC2 instance e.g. `t2.micro`"
}

variable "min_size" {
  description = "The minimum number of instance in the ASG"
}

variable "max_size" {
  description = "The maximum number of instances in the ASG"
}