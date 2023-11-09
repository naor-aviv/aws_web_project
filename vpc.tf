################################ VPC MODULE ################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.18"

  name                 = local.resource_name
  cidr                 = local.vpc_cidr
  enable_dns_hostnames = false
  instance_tenancy     = "default"

  azs             = [local.az1, local.az2]
  private_subnets = [local.private_app_subnet_az1_cidr, local.private_app_subnet_az2_cidr]
  public_subnets  = [local.public_subnet_az1_cidr, local.public_subnet_az2_cidr]

  create_igw               = true
  single_nat_gateway       = true
  enable_nat_gateway       = true
  one_nat_gateway_per_az   = false
  default_route_table_name = module.vpc.public_route_table_ids[0]

   tags = {
     Name = local.resource_name
   }

  public_subnet_tags = {
  Name = local.public_subnets_name
  }
  private_subnet_tags = {
    Name = local.private_subnets_name
  }
  private_route_table_tags = {
    Name = local.private_route_table_name
  }
  public_route_table_tags = {
    Name = local.public_route_table_name
  }

}

output "vpc_name" {
  value = module.vpc.name
}