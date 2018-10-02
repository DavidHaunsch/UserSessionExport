variable "aws_region" {
  default = "us-west-2"
}

variable "aws_prefix" {
  default = "prefix"
}

variable "aws_flavor_elastic" {
  default = "m4.large"
}

variable "aws_flavor_loadgen" {
  default = "t2.medium"
}

variable "aws_flavor_sockshop" {
  default = "m4.xlarge"
}

variable "dynatrace_environment_id" {}

variable "dynatrace_api_token" {}
