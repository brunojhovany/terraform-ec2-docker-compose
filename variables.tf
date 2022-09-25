variable "project" {
  type        = string
  default     = "medusa"
  description = "name of project"
}

variable "project_domain_name" {
  type        = string
  description = "domain name for this project"
}

variable "project_remote_workdir" {
  type        = string
  description = "workdir in remote ec2 instance"
  default     = "/home/ubuntu/app"
}

variable "project_mysql_password" {
  type        = string
  description = "secure password for mysql container"
}

variable "project_container_image_api" {
  type        = string
  description = "docker image for api"
}

variable "project_container_image_webapp" {
  type        = string
  description = "docker image for web app"
}

variable "project_key" {
  type = string
  description = "ssh key name"
}

variable "project_subdomains" {
  type = list(string)
  description = "subdomains for services"
  default = [
    "monitor.",
    "api.",
    ""
  ]
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "region of aws data center"
}

variable "availability_zones_count" {
  description = "The number of AZs."
  type        = number
  default     = 2
}

variable "ec2_instance_size" {
  type        = string
  default     = "t2.micro"
  description = "The EC2 instance size"
}

variable "ec2_root_volume_size" {
  type = string
  default     = "15"
  description = "The volume size for the root volume in GiB"
}
variable "ec2_root_volume_type" {
  type        = string
  default     = "gp3"
  description = "The type of data storage: standard, gp2, io1"
}

variable "ec2_root_volume_delete_on_termination" {
  default     = true
  description = "Delete the root volume on instance termination."
}


variable "traefik_admin_user" {
  type        = string
  description = "admin user for traefik dashboard"
  default     = "admin"
}

variable "traefik_admin_password" {
  type        = string
  description = "password for traefik admin dashboard"
  sensitive   = true
}

variable "traefik_acme_email" {
  type        = string
  description = "email for acme ssl certificate"
}