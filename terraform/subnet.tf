resource "aws_default_vpc" "default" {}

resource "aws_subnet" "uemload" {
  vpc_id = "${aws_default_vpc.default.id}"
  cidr_block = "172.31.100.0/24"
  tags {
    Name = "uemload"
  }
}
