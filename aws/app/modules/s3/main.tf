data "aws_iam_policy_document" "bucket" {
  statement {
    sid = "RestrictBucketAccessToIAMRole"

    principals {
      type        = "AWS"
      identifiers = [var.lambda_role_arn]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${module.s3_bucket.s3_bucket_arn}/*",
    ]
  }
}


module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  name = "s3-bucket"

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  # Bucket policy
  attach_policy = true
  policy        = data.aws_iam_policy_document.bucket.json

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = module.kms.key_id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle_rule = [{
    id      = "expiration"
    enabled = true

    transition = {
      days          = 30
      storage_class = "GLACIER"
    }

    # In the case of delete policy
    # expiration = {
    #   days                         = 90
    #   expired_object_delete_marker = true
    # }

    # noncurrent_version_expiration = {
    #   newer_noncurrent_versions = 5
    #   days                      = 30
    # }
  }]


  lambda_notifications = {
    face = {
      function_arn  = var.lambda_function_arn
      function_name = var.lambda_function_name
      events        = ["s3:ObjectCreated:Post"]
    }
  }
}

