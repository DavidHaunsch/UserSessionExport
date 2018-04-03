# select elastic AMI built with Packer
data "aws_ami" "elastic_ami" {
  most_recent = true
  name_regex = "^elastic.*"
  owners = ["self"]
}

resource "aws_instance" "elastic" {
  ami = "${data.aws_ami.elastic_ami.id}"
  instance_type = "${var.aws_flavor}"
  key_name = "${var.aws_keypair_name}"
  subnet_id= "${aws_subnet.uemload.id}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.elastic_sg.id}"]

  tags {
    Name = "Elasticsearch and Kibana"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("${var.private_key_file}")}"
  }

  provisioner "remote-exec" {
    inline = [
      "wget -nv -O Dynatrace-OneAgent.sh \"https://${var.dynatrace_environment_id}.live.dynatrace.com/api/v1/deployment/installer/agent/unix/default/latest?Api-Token=${var.dynatrace_api_token}&arch=x86&flavor=default\"",
      "sudo /bin/sh Dynatrace-OneAgent.sh  APP_LOG_CONTENT_ACCESS=1", 
      "sudo sed -i 's/PRIVATE_IP/${aws_instance.elastic.private_ip}/g' /etc/elasticsearch/elasticsearch.yml",
      "sudo sed -i 's/PRIVATE_IP/${aws_instance.elastic.private_ip}/g' /etc/kibana/kibana.yml",
      "sudo sed -i 's/PRIVATE_IP/${aws_instance.elastic.private_ip}/g' /etc/nginx/sites-available/default",
      "sudo service elasticsearch start",
      "sudo service kibana start",
      "sudo service nginx start"
    ]
  }
}
