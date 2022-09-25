data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "http" "clientip" {
  url = "https://ipv4.icanhazip.com/"
}


locals {
  traefikconfig = <<TRAEFIKCONFIG
  defaultEntryPoints = ["http", "https"]

  [entryPoints]
    [entryPoints.dashboard]
      address = ":8080"
      [entryPoints.dashboard.auth]
        [entryPoints.dashboard.auth.basic]
          users = ["${var.traefik_admin_user}:${bcrypt(var.traefik_admin_password, 6)}"]
    [entryPoints.http]
      address = ":80"
        [entryPoints.http.redirect]
          entryPoint = "https"
    [entryPoints.https]
      address = ":443"
        [entryPoints.https.tls]

  [api]
  entrypoint="dashboard"

  [acme]
  email = "${var.traefik_acme_email}"
  storage = "acme.json"
  entryPoint = "https"
  onHostRule = true
    [acme.httpChallenge]
    entryPoint = "http"

  [docker]
  domain = "${var.project_domain_name}"
  watch = true
  network = "web"
  
  TRAEFIKCONFIG
}

locals {
  docker_compose = <<DOCKERCOMPOSE
  version: "3.6"
  services:
    traefik:
      image: traefik:1.7.2-alpine
      container_name: traefik
      labels:
        - traefik.frontend.rule=Host:monitor.${var.project_domain_name}
        - traefik.port=8080
      ports:
        - 80:80
        - 8080:8080
        - 443:443
      volumes:
        - /var/run/docker.sock:/var/run/docker.sock:Z
        - ./traefik.toml:/traefik.toml:Z
        - ./acme.json:/acme.json:Z
      networks:
        - web
    db:
      image: mysql
      command: --default-authentication-plugin=mysql_native_password
      restart: unless-stopped
      ports:
        - "3306:3306"
      environment:
        MYSQL_ROOT_PASSWORD: ${var.project_mysql_password}
      volumes:
        - mysql_data:/var/lib/mysql
      networks:
        - web
    medusa-api:
      depends_on: 
        - db
      image: ${var.project_container_image_api}
      labels:
        - traefik.backend=apimedusa
        - traefik.frontend.rule=Host:api.${var.project_domain_name}
        - traefik.docker.network=web
        - traefik.port=5080
      restart: always
      networks:
        - web
    medusawebapp:
      image: ${var.project_container_image_webapp}
      labels:
        - traefik.backend=webpage
        - traefik.frontend.rule=Host:${var.project_domain_name}
        - traefik.docker.network=web
        - traefik.port=80
      networks:
        - web

  volumes:
    mysql_data:

  networks:
    web:
      external: true
      name: web
  DOCKERCOMPOSE
}