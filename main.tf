resource "aws_instance" "server_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  user_data     = file("user_data.yaml")
  key_name      = "bruno_key"
  vpc_security_group_ids = [
    aws_default_security_group.default.id
  ]
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/bruno_key.pem")
    timeout     = "2m"
    host        = self.public_ip
  }

  provisioner "file" {
    content     = local.traefikconfig
    destination = "/tmp/traefik.toml"
  }
  provisioner "file" {
    content     = local.docker_compose
    destination = "/tmp/docker-compose.yaml"
  }
  provisioner "remote-exec" {
    inline = [
      "set -x",
      "cd /tmp",
      "sudo chmod +x bootstrap_config.sh",
      "sudo /bin/bash -c ./bootstrap_config.sh"
    ]
  }
  tags = {
    Name = var.project
  }
}