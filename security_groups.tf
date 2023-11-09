################################ BASTION SECURITY GROUP MODULE ################################

module "bast_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "~> 4.16"
  name        = local.resource_name
  description = "BASTION for app"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh ports"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port = -1
      to_port   = -1
      protocol  = -1
    }
  ]
}

################################ ALB SECURITY GROUP MODULE ################################

module "alb_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "~> 4.16"
  name        = local.resource_name
  description = "ALB sg"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "web ports"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port = -1
      to_port   = -1
      protocol  = -1
    }
  ]
}
################################ WEB SECURITY GROUP MODULE ################################

module "web_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "~> 4.16"
  name        = local.resource_name
  description = "WEB sg"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      description              = "web ports"
      source_security_group_id = module.alb_sg.security_group_id
    },
    {
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      description              = "bastion ports"
      source_security_group_id = module.bast_sg.security_group_id
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port = -1
      to_port   = -1
      protocol  = -1
    }
  ]
}

################################ DB SECURITY GROUP MODULE ################################

module "db_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "~> 4.16"
  name        = local.resource_name
  description = "DB sg"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      description              = "mysql ports"
      source_security_group_id = module.web_sg.security_group_id
    },
  ]
  egress_with_cidr_blocks = [
    {
      from_port = -1
      to_port   = -1
      protocol  = -1
    }
  ]
}



