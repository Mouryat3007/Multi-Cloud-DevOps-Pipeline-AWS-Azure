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
  default = "vpc-0f86ea073cfae2743"
  description = "Use default VPC if empty"
}

variable "subnets" {
  type    = list(string)
  default = ["subnet-0cc2f2bdb2f18e273"]
  description = "Use default VPC subnets if empty"
}
