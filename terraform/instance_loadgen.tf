resource "aws_instance" "loadgen" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.aws_flavor_loadgen}"
  key_name = "${var.aws_keypair_name}"
  subnet_id= "${aws_subnet.uemload.id}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.loadgen_sg.id}"]

  tags {
    Name = "${var.aws_prefix} Load Generator"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("${var.private_key_file}")}"
  }

  provisioner "file" {
    source = "../files/loadgen.sh"
    destination = "/home/ubuntu/loadgen.sh"
  }

  provisioner "file" {
    source = "../files/iphone8.js"
    destination = "/home/ubuntu/iphone8.js"
  }

  provisioner "file" {
    source = "../files/macos.js"
    destination = "/home/ubuntu/macos.js"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install python fontconfig",
      "wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2",
      "bzip2 -d phantomjs-2.1.1-linux-x86_64.tar.bz2",
      "tar -xvf phantomjs-2.1.1-linux-x86_64.tar",
      "sudo cp phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/bin/phantomjs",
      "git clone git://github.com/casperjs/casperjs.git",
      "sudo ln -sf /home/ubuntu/casperjs/bin/casperjs /usr/local/bin/casperjs",
      "sed -i 's/PUBLIC_IP/${aws_instance.sockshop.public_ip}/g' /home/ubuntu/*.js",
      "chmod +x /home/ubuntu/loadgen.sh",
      "echo \"* * * * * /home/ubuntu/loadgen.sh\" | crontab -"
    ]
  }
}
