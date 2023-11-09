module "asg_iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 5.5"

  name        = "asg-to-s3-access"
  path        = "/"
  description = "ASG access to S3 IAM policy"

  policy = data.aws_iam_policy_document.asg_iam_policy.json

}

data "aws_iam_policy_document" "asg_iam_policy" {
  policy_id = "ec2-access-to-s3"

  statement {
    sid    = "GetQSS3BucketObjects"
    effect = "Allow"
    actions = [
      "s3:DeleteObject",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject"
    ]
    resources = [
      #module.s3_bucket.s3_bucket_arn
      "arn:aws:s3:::${module.s3_bucket.s3_bucket_id}/*",
      "arn:aws:s3:::${module.s3_bucket.s3_bucket_id}"
    ]
  }
}

# Creating Role
module "iam_assumable_roles" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 5.5"

  create_role             = true
  role_name               = "s3-access-role"
  create_instance_profile = true
  trusted_role_services   = ["ec2.amazonaws.com"]
  role_requires_mfa       = false

  custom_role_policy_arns = [
    module.asg_iam_policy.arn
  ]
}