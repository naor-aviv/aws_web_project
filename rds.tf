module "db" {
  source = "terraform-aws-modules/rds/aws"
  # version    = "4.3.0"
  version    = "5.0.3"
  identifier = "webdb"

  engine            = "mysql"
  engine_version    = "8.0.28"
  instance_class    = "db.t3.micro"
  allocated_storage = 5

  db_name  = "webdb"
  username = "admin"
  port     = "3306"
  create_random_password = true

  skip_final_snapshot = true

  #iam_database_authentication_enabled = true

  vpc_security_group_ids = [module.db_sg.security_group_id]

  tags = {
    Owner       = "Naor"
    Environment = "dev"
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]
}

output "rds_endpoint" {
  value       = module.db.db_instance_endpoint
  description = "The RDS endpoint:"
}
