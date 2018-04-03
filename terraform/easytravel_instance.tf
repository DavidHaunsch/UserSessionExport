# select easytravel AMI built with Packer
data "aws_ami" "easytravel_ami" {
  most_recent = true
  name_regex = "^easytravel.*"
  owners = ["self"]
}

resource "aws_instance" "easytravel" {
  ami = "${data.aws_ami.easytravel_ami.id}"
  instance_type = "${var.aws_flavor}"
  key_name = "${var.aws_keypair_name}"
  subnet_id= "${aws_subnet.uemload.id}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.easytravel_sg.id}"]

  tags {
    Name = "Easytravel"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("${var.private_key_file}")}"
  }

  provisioner "remote-exec" {
    inline = [
      "wget -O Dynatrace-OneAgent.sh \"https://${var.dynatrace_environment_id}.live.dynatrace.com/api/v1/deployment/installer/agent/unix/default/latest?Api-Token=${var.dynatrace_api_token}&arch=x86&flavor=default\"",
      "sudo /bin/sh Dynatrace-OneAgent.sh  APP_LOG_CONTENT_ACCESS=1", 
      "sudo sed -i 's/PUBLIC_IP/${aws_instance.easytravel.public_ip}/g' /etc/systemd/system/uemload.service",
      "sudo systemctl daemon-reload",
      "sudo service easytravel start",
      "sudo service uemload start"
    ]
  }
}
