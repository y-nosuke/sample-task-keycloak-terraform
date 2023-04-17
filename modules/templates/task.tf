#####################################################
# Variables
#####################################################
variable "mail_domain" {
  type        = string
  description = "メールドメイン"
}

variable "smtp_host" {
  type        = string
  description = "SMTP ホスト名"
}

variable "smtp_port" {
  type        = number
  description = "SMTP ポート番号"
}

variable "task_api_url" {
  type        = string
  description = "TASK API URL"
}

variable "users" {
  type = list(object({
    username   = string
    first_name = string
    last_name  = string
    email      = string
    roles      = list(string)
  }))
}

variable "initial_password" {
  type = string
}

#####################################################
# Locals
#####################################################

#####################################################
# Outputs
#####################################################

#####################################################
# Modules
#####################################################
module "task" {
  source = "../modules"

  realm                    = "sample"
  smtp_host                = var.smtp_host
  smtp_port                = var.smtp_port
  mail_from                = "noreply@${var.mail_domain}"
  access_token_lifespan    = "30m"
  sso_session_idle_timeout = "24h"
  sso_session_max_lifespan = "24h"

  resource_servers = {
    task-api = {
      standard_flow_enabled = true
      root_url              = var.task_api_url
      valid_redirect_uris   = ["${var.task_api_url}/*"]
    }
  }

  clients = {
    postman = {
      client_service_account_role = "POSTMAN"
      standard_flow_enabled       = false
      optional_scopes = [
        "create:task",
        "read:task",
        "update:task",
        "delete:task",
      ]
    }
  }

  client_scopes = [
    "create:task",
    "read:task",
    "update:task",
    "delete:task",
  ]

  role_scope_mappings = {
    GUEST = [
      "read:task",
    ]
    NORMAL_USER = [
      "create:task",
      "read:task",
      "update:task",
      "delete:task",
    ]
    ADMINISTRATOR = [
      "create:task",
      "read:task",
      "update:task",
      "delete:task",
    ]
  }

  client_role_scope_mappings = {
    POSTMAN = [
      "create:task",
      "read:task",
      "update:task",
      "delete:task",
    ]
  }

  realm_roles = {
    GUEST         = "ゲスト用のロール"
    NORMAL_USER   = "一般ユーザ用のロール"
    ADMINISTRATOR = "管理者用のロール"
  }

  client_roles = {
    POSTMAN = { client = "postman", description = "postman自身に割り当てるロール" }
  }

  users            = var.users
  initial_password = var.initial_password
}
