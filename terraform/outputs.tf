output "Sock Shop" {
  value = "${aws_instance.sockshop.private_ip}/${aws_instance.sockshop.public_ip}"
}

output "Elastic/Kibana" {
  value = "${aws_instance.elastic.private_ip}/${aws_instance.elastic.public_ip}"
}

output "Load Generator" {
  value = "${aws_instance.loadgen.private_ip}/${aws_instance.loadgen.public_ip}"
}