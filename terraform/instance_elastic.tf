resource "aws_instance" "elastic" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.aws_flavor_elastic}"
  key_name = "${var.aws_keypair_name}"
  subnet_id= "${aws_subnet.uemload.id}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.elastic_sg.id}"]

  tags {
    Name = "${var.aws_prefix} Elasticsearch and Kibana"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("${var.private_key_file}")}"
  }

  provisioner "remote-exec" {
    inline = [
      "wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -",
      "echo \"deb https://artifacts.elastic.co/packages/6.x/apt stable main\" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list",
      "sudo apt-get -y update",
      "sudo apt-get -y install elasticsearch kibana openjdk-8-jre-headless nginx apt-transport-https",
      "sudo sed -i 's/#network.host.*/network.host: ${aws_instance.elastic.private_ip}/' /etc/elasticsearch/elasticsearch.yml",
      "sudo sed -i 's/#http.port.*/http.port: 9200/' /etc/elasticsearch/elasticsearch.yml",
      "sudo sed -i 's/#server.port.*/server.port: 5601/' /etc/kibana/kibana.yml",
      "sudo sed -i 's/#server.host.*/server.host: ${aws_instance.elastic.private_ip}/' /etc/kibana/kibana.yml",
      "sudo sed -i 's/#elasticsearch.url.*/elasticsearch.url: \"http:\\/\\/${aws_instance.elastic.private_ip}:9200\"/' /etc/kibana/kibana.yml",
      "sudo sed -i 's/try_files.*/proxy_pass http:\\/\\/${aws_instance.elastic.private_ip}:5601;/' /etc/nginx/sites-available/default",
      "sudo service elasticsearch start",
      "sudo service kibana start",
      "sudo service nginx restart"
    ]
  }
}
