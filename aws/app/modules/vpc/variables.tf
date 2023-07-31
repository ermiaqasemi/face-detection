variable "name" {
  description = "Name of the VPC"
  type        = string
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "enable_datadog_endpoints" {
  type    = bool
  default = false
}

variable "enable_cloudwatch_endpoints" {
  type    = bool
  default = false
}

variable "enable_ecr_endpoints" {
  type    = bool
  default = false
}

variable "enable_s3_endpoints" {
  type    = bool
  default = false
}

variable "public_subnet_tags" {
  type = map(any)
}

variable "private_subnet_tags" {
  type = map(any)
}
