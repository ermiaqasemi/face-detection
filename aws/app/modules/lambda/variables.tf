# variables.tf

variable "vpc_subnets" {
  type        = list(string)
  description = "List of VPC subnet IDs where the Lambda function will be placed."
}

variable "default_security_group_id" {
  type        = string
  description = "ID of the default security group in the VPC."
}
