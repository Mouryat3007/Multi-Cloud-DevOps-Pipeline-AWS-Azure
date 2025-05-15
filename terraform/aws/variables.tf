variable "aws_region" {}
variable "cluster_name" {}
variable "subnets" {
  type = list(string)
}
variable "vpc_id" {}
