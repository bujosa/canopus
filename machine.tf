resource "aws_instance" "machine01" {
  ami                         = "ami-007fae589fdf6e955"
  instance_type               = "t2.small"
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.bujosa.id]

  root_block_device {
    volume_size = 20 #20 Gb
  }

  tags = {
    Name     = "${var.author}.machine01"
    Author   = var.author
    Date     = "2022.03.13"
    Location = "Paris"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y docker httpd-tools git",
      "sudo usermod -a -G docker ec2-user",
      "sudo curl -L https://github.com/docker/compose/releases/download/1.22.0-rc2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo chkconfig docker on",
      "sudo service docker start",
    ]
  }

  provisioner "remote-exec" {
    script = "./launch-containers.sh"
  }

}
