# S3
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.4"

  bucket        = "tf-setup"
  acl           = "private"
  force_destroy = true
  # tags = {
  #   local.resource_name
  # }
}

# Inject the DB endpoint and password to the web app file on S3 bucket

resource "aws_s3_object" "s3_user_data" {
  bucket = module.s3_bucket.s3_bucket_id
  key    = "./two-tiers-web-application/cred.tftpl"
  content = templatefile("./two-tiers-web-application/cred.tftpl", {
    rds_endpoint = module.db.db_instance_endpoint
    rds_password = module.db.db_instance_password
  })
}

resource "aws_s3_object" "s3_files" {
  for_each = fileset("./two-tiers-web-application/", "**")

  bucket        = module.s3_bucket.s3_bucket_id
  key           = "./two-tiers-web-application/${each.value}"
  source        = "./two-tiers-web-application/${each.value}"
  force_destroy = true
}

