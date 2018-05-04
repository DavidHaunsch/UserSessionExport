# Configuration of AWS provider
provider "aws" {
  region = "${var.aws_region}"
  version = "~> 1.17"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  name_regex = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"
  owners = ["099720109477"]
}