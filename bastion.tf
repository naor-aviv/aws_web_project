module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.5"

  name = "tf_bastion_host"

  ami                         = local.ami_id
  instance_type               = "t2.micro"
  key_name                    = module.key_pair.key_pair_name
  monitoring                  = true
  vpc_security_group_ids      = [module.bast_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  tags = {
    Name = local.resource_name
    Terraform   = "true"
    Environment = "dev"
  }
}