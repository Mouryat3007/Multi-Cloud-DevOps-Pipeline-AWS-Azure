provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  count   = var.vpc_id == "" ? 1 : 0
  default = true
}

data "aws_subnets" "default" {
  count = length(var.subnets) == 0 ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default[0].id]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.29.0"  # specify exact working version

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  vpc_id     = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.default[0].id
  subnet_ids = length(var.subnets) > 0 ? var.subnets : data.aws_subnets.default[0].ids

  # AWS Auth is managed automatically now, no manage_aws_auth param needed

  node_groups = {
    default = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_types   = ["t2.medium"]
    }
  }
}
