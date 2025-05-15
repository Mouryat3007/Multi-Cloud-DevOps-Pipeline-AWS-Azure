variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "my-eks-cluster"
}

variable "vpc_id" {
  type    = string
  default = ""
  description = "Use default VPC if empty"
}

variable "subnets" {
  type    = list(string)
  default = []
  description = "Use default VPC subnets if empty"
}
