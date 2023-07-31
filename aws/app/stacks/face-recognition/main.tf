module "vpc" {
  source = "../../modules/vpc"

  name            = var.vpc_name
  cidr            = var.vpc_cidr_block
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_datadog_endpoints    = var.vpc_enable_datadog_endpoints
  enable_ecr_endpoints        = var.vpc_enable_ecr_endpoints
  enable_s3_endpoints         = var.vpc_enable_s3_endpoints
  enable_cloudwatch_endpoints = var.vpc_enable_cloudwatch_endpoints
}

module "lambda_uploader" {
  source = "../../modules/lambda"

  name                      = var.lambda_name
  vpc_id                    = module.vpc.vpc_id
  vpc_private_subnets       = module.vpc_private_subnets
  default_security_group_id = module.vpc_default_security_group_id
}

module "lambda_face" {
  source = "../../modules/lambda"

  name                      = var.lambda_name
  vpc_id                    = module.vpc.vpc_id
  vpc_private_subnets       = module.vpc_private_subnets
  default_security_group_id = module.vpc_default_security_group_id
}

module "s3" {
  source = "../../modules/s3"

  name                 = var.s3_name
  lambda_function_arn  = moudle.lambda_face.lambda_function_arn
  lambda_role_arn      = moudle.lambda_face.lambda_role_arn
  lambda_function_name = module.lambda_face.lambda_function_name
}

module "api" {
  source = "../../modules/s3"

  lambda_function_arn = moudle.lambda_uploader.lambda_function_arn
}
