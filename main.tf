provider "aws" {
  region = "${var.region}"
}

data "aws_ami" "ami" {
  most_recent = true
  owners = ["099720109477"]
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "instance" {
  ami = "${data.aws_ami.ami.image_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.ssh_key_name}"
  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.sg.id}"]
  associate_public_ip_address = true

  tags {
    Name = "${var.project_name}"
  }

  root_block_device {
    volume_size = "${var.volume_size}"
  }

  connection {
    user = "ubuntu"
    private_key = "${file("${var.ssh_private_key}")}"
  }

  provisioner "file" {
    content = "${file("crane.yml")}"
    destination = "~/crane.yml"
  }

  provisioner "file" {
    content = "${var.init_script}"
    destination = "~/init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ~/config"
    ]
  }

  provisioner "file" {
    source = "${path.cwd}/config/"
    destination = "~/config/"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get install -y apt-transport-https ca-certificates",
      "sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D",
      "echo \"deb https://apt.dockerproject.org/repo ubuntu-xenial main\" | sudo tee /etc/apt/sources.list.d/docker.list",
      "sudo apt-get update",
      "sudo apt-get install -y docker-engine",
      "sudo service docker start",
      "sudo usermod -aG docker $USER",
      "bash -c \"`curl -sL https://raw.githubusercontent.com/michaelsauter/crane/v2.9.0/download.sh`\" && sudo mv crane /usr/local/bin/crane"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "docker login quay.io -u dontspamus -p ${var.quay_password}",
      "chmod +x ./init.sh",
      "./init.sh",
      "crane lift"
    ]
  }
}


resource "aws_route53_record" "dns" {
  zone_id = "${var.zone_id}"
  name = "${var.host_name}"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.instance.public_ip}"]
}
