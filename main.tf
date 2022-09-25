resource "aws_instance" "server_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_size
  user_data     = file("user_data.yaml")
  key_name      = var.project_key
  vpc_security_group_ids = [
    aws_default_security_group.default.id
  ]
  
  root_block_device {
    volume_size           = var.ec2_root_volume_size
    volume_type           = var.ec2_root_volume_type
    delete_on_termination = var.ec2_root_volume_delete_on_termination
  }
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