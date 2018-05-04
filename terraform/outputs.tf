output "elastic_public_ip" {
  value = "${aws_instance.elastic.public_ip}"
}

output "loadgen_public_ip" {
  value = "${aws_instance.loadgen.public_ip}"
}

output "sockshop_public_ip" {
  value = "${aws_instance.sockshop.public_ip}"
}
