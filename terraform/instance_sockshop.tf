resource "aws_instance" "sockshop" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.aws_flavor}"
  key_name = "${var.aws_keypair_name}"
  subnet_id= "${aws_subnet.uemload.id}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.sockshop_sg.id}"]

  tags {
    Name = "Sock Shop"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("${var.private_key_file}")}"
  }

  provisioner "remote-exec" {
    inline = [
      "wget -O Dynatrace-OneAgent.sh \"https://${var.dynatrace_environment_id}.live.dynatrace.com/api/v1/deployment/installer/agent/unix/default/latest?Api-Token=${var.dynatrace_api_token}&arch=x86&flavor=default\"",
      "sudo /bin/sh Dynatrace-OneAgent.sh APP_LOG_CONTENT_ACCESS=1",
      "sudo apt-get -y update",
      "sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "sudo apt-get -y update",
      "sudo apt-get -y install docker-ce docker-compose",
      "git clone https://github.com/microservices-demo/microservices-demo",
      "sudo docker-compose -f microservices-demo/deploy/docker-compose/docker-compose.yml up -d"
    ]
  }
}
