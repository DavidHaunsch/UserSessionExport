output "Easytravel" {
  value = "${aws_instance.easytravel.private_ip}/${aws_instance.easytravel.public_ip}"
}

output "Elastic" {
  value = "${aws_instance.elastic.private_ip}/${aws_instance.elastic.public_ip}"
}
