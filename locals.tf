locals {
  rds_db_name                 = "webapp"
  resource_name               = "tf_web_app"
  az1                         = "eu-central-1a"
  az2                         = "eu-central-1b"
  project                     = "naor-tf-project"
  vpc_cidr                    = "172.29.0.0/16"
  public_subnet_az1_cidr      = "172.29.3.0/24"
  public_subnet_az2_cidr      = "172.29.4.0/24"
  private_app_subnet_az1_cidr = "172.29.13.0/24"
  private_app_subnet_az2_cidr = "172.29.14.0/24"
  ami_id                      = "ami-0e2031728ef69a466"
  public_subnets_name         = "public_subnet"
  private_subnets_name        = "private_subnet"
  private_route_table_name    = "private_route_table"
  public_route_table_name     = "public_route_table"
}

