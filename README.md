# Deploy AWS EC2 with docker docker-compose and traefik
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=flat&logo=terraform&logoColor=white)
![Docker](https://img.shields.io/badge/docker-blue.svg?style=flat&logo=docker&logoColor=white)
![Shell Script](https://img.shields.io/badge/bash_script-%23121011.svg?style=flat&logo=gnu-bash&logoColor=white) 

This project is a example deployment with terraform, docker, docker-compose and traefik for service discovery and service proxy.

#### We will use of
- Terraform
- AWS cli
- Bash

## Vars
> variables you should use in your `terraform.tfvars`
> First you need to create it and paste the following variables with your custom value
```
traefik_admin_user             = "example_user"
traefik_admin_password         = "exhample_passwordzxdd"
traefik_acme_email             = "example@example.com"
project_domain_name            = "example.com"
project_mysql_password         = "exhample_passwordzxdd"
project_container_image_api    = "example_api:latest"
project_container_image_webapp = "nginx:latest"
project_key = "example_key"
```

## Security group
> All the scurity groups config used are in the file security_group.tf

| Group | Type | CIDR | Ports | Description |
| ----- | ---- | ---- | ----- | ----------- |
| default | egress | 0.0.0.0/0 | 0:0/-1 | all outgoing traffics |
| default | ingress | 0.0.0.0/0 | 80:80/tcp | web-server | 
| default | ingress | 0.0.0.0/0 | 443:443/tcp | secure-web-server | 
| default | ingress | 0.0.0.0/32 | 8080:8080/tcp | traefik-dashboard | 
| default | ingress | 0.0.0.0/32 | 22:22/tcp | ssh connection |

## Outputs
| Name | Description |
| ---- | ----------- |
| public_ip | public ip of instencce |


## Terraform execution
```
# to install plugins
terraform init

# to preview the result
terraform plan

# to create the resources in the provider
terraform apply
```