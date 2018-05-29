variable "aws_region" {
  default = "us-west-1"
}

variable "aws_prefix" {
  default = "prefix"
}

variable "aws_flavor_elastic" {
  default = "t2.xlarge"
}

variable "aws_flavor_loadgen" {
  default = "t2.small"
}

variable "aws_flavor_sockshop" {
  default = "t2.xlarge"
}

variable "aws_keypair_name" {
  default = ""
}

variable "dynatrace_environment_id" {
  default = ""
}

variable "dynatrace_api_token" {
  default = ""
}

variable "private_key_file" {
  default = ""
}
