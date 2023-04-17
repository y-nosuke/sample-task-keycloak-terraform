#####################################################
# Variables
#####################################################
variable "realm" {
  type        = string
  description = "REALM"
}

variable "mail_from" {
  type        = string
  description = "メール From"
}

variable "smtp_host" {
  type        = string
  description = "SMTP ホスト名"
}

variable "smtp_port" {
  type        = number
  description = "SMTP ポート番号"
}

variable "access_token_lifespan" {
  type        = string
  description = "ACCESS TOKEN LIFESPAN"
}

variable "sso_session_idle_timeout" {
  type        = string
  description = "SSO SESSION IDLE TIMEOUT"
}

variable "sso_session_max_lifespan" {
  type        = string
  description = "SSO SESSION MAX LIFESPAN"
}

#####################################################
# Locals
#####################################################

#####################################################
# Outputs
#####################################################

#####################################################
# Resources
#####################################################
resource "keycloak_realm" "this" {
  realm       = var.realm
  login_theme = "keycloak"
  enabled     = true

  reset_password_allowed   = true
  login_with_email_allowed = true

  smtp_server {
    host = var.smtp_host
    port = var.smtp_port
    from = var.mail_from
    ssl  = false
  }

  access_token_lifespan    = var.access_token_lifespan
  sso_session_idle_timeout = var.sso_session_idle_timeout
  sso_session_max_lifespan = var.sso_session_max_lifespan
}
