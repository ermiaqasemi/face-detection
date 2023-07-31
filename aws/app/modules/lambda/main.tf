module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "5.3.0"

  function_name = "lambda-in-vpc"
  description   = "My awesome lambda function to detect face"
  handler       = "index.lambda_handler"
  runtime       = "Node.js18.x"

  source_path = "${path.module}/functions/recognition"

  environment_variables = {
    bucket = "s3-bucket"
  }

  vpc_subnet_ids                     = var.vpc_subnets
  vpc_security_group_ids             = [var.default_security_group_id]
  attach_network_policy              = true
  replace_security_groups_on_destroy = true
  replacement_security_group_ids     = [var.default_security_group_id]
}
