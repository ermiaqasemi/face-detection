# variables.tf

variable "lambda_role_arn" {
  description = "The ARN of the IAM role associated with the Lambda function."
}

variable "lambda_function_arn" {
  description = "The ARN of the Lambda function."
}

variable "lambda_function_name" {
  description = "The name of the Lambda function."
}
