
################################ ASG FRONT MODULE ################################

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 7.2"
  depends_on = [
    module.db
  ]

  # Autoscaling group
  name                       = "tf_asg"
  create_launch_template     = true
  security_groups            = [module.web_sg.security_group_id]
  use_mixed_instances_policy = false
  target_group_arns          = [aws_lb_target_group.test.arn]

  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 2
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]

  # Launch template
  launch_template_name    = "tf-lt"
  launch_template_version = "$Default"
  update_default_version  = true

  image_id          = local.ami_id
  instance_type     = "t2.micro"
  enable_monitoring = false
  key_name          = module.key_pair.key_pair_name

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = false
        volume_size           = 8
        volume_type           = "gp2"
      }
    }
  ]

  # IAM role & instance profile
  create_iam_instance_profile = false
  iam_instance_profile_arn    = module.iam_assumable_roles.iam_instance_profile_arn

  user_data = (base64encode(templatefile("front_user_data.sh", {
    s3_name = module.s3_bucket.s3_bucket_id
  })))

  tags = {
    Name = local.resource_name
    Environment = "dev"
    Project     = "naor-tf"
  }
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"
  
  key_name           = local.resource_name
  create_private_key = true
}

output "key_pair_private_key" {
  value       = module.key_pair.private_key_pem
  description = "The Private key for bastion host:"
}
