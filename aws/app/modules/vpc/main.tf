data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

locals {
  datadong_endpoint_services = {
    agent-logs = "com.amazonaws.vpce.us-east-1.vpce-svc-025a56b9187ac1f63"
    api        = "com.amazonaws.vpce.us-east-1.vpce-svc-064ea718f8d0ead77"
    metrics    = "com.amazonaws.vpce.us-east-1.vpce-svc-09a8006e245d1e7b8"
    containers = "com.amazonaws.vpce.us-east-1.vpce-svc-0ad5fb9e71f85fe99"
    process    = "com.amazonaws.vpce.us-east-1.vpce-svc-0ed1f789ac6b0bde1"
    profiling  = "com.amazonaws.vpce.us-east-1.vpce-svc-022ae36a7b2472029"
    traces     = "com.amazonaws.vpce.us-east-1.vpce-svc-0355bb1880dfa09c2"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name            = var.name
  cidr            = var.cidr
  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags  = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags
}


################################################################################
### Connect to Datadog over AWS PrivateLink to optimise costs
################################################################################
resource "aws_security_group" "endpoint_eni_security_group" {
  description = "Allow inbound and outbunf traffic from VPC Security Groups to ENI"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "${module.vpc.vpc_cidr_block}"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"    = "${var.name}-datadog-eni"
    "Managed" = "Terraform"
  }
}
resource "aws_vpc_endpoint" "datadog" {
  for_each          = var.enable_datadog_endpoints ? local.datadong_endpoint_services : {}
  vpc_id            = module.vpc.vpc_id
  service_name      = each.value
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    module.vpc.default_security_group_id, aws_security_group.endpoint_eni_security_group.id
  ]

  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = true

  tags = {
    Name    = "${var.name}-datadog-${each.key}"
    Managed = "Terraform"
  }
}

################################################################################
### Setting Aws private link for S3 & ECR to reduce costs
################################################################################
resource "aws_vpc_endpoint" "ecr" {
  count             = var.enable_ecr_endpoints ? 1 : 0
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    module.vpc.default_security_group_id, aws_security_group.endpoint_eni_security_group.id
  ]

  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = true

  tags = {
    Name    = "${var.name}-ecr-dkr"
    Managed = "Terraform"
  }
}

resource "aws_vpc_endpoint" "s3" {
  count             = var.enable_s3_endpoints ? 1 : 0
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = module.vpc.private_route_table_ids

  tags = {
    Name    = "${var.name}-s3"
    Managed = "Terraform"
  }
}

################################################################################
### Setting Aws private link for cloudwatch to reduce costs
################################################################################
resource "aws_vpc_endpoint" "cloudwatch" {
  count             = var.enable_cloudwatch_endpoints ? 1 : 0
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.logs"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    module.vpc.default_security_group_id, aws_security_group.endpoint_eni_security_group.id
  ]

  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = true

  tags = {
    Name    = "${var.name}-cloudwatch"
    Managed = "Terraform"
  }
}
