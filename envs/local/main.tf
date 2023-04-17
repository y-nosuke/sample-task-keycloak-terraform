#####################################################
# Providers
#####################################################
terraform {
  backend "local" {}
  required_providers {
    keycloak = {
      source = "mrparkers/keycloak"
    }
  }
}

variable "client_id" {}
variable "username" {}
variable "password" {}
variable "url" {}

provider "keycloak" {
  client_id = var.client_id
  username  = var.username
  password  = var.password
  url       = var.url
}

#####################################################
# Locals
#####################################################

#####################################################
# Modules
#####################################################
module "keycloak" {
  source = "../../modules/templates"

  task_api_url = "http://localhost:1323"

  mail_domain = "example.com"
  smtp_host   = "mailhog"
  smtp_port   = 1025

  users            = var.users
  initial_password = var.user_initial_password
}
