#####################################################
# Variables
#####################################################
variable "environment_prefix" {
  description = "環境名のprefix ex) dev, prd"
  type        = string
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

variable "user_initial_password" {
  description = "KeyCloakユーザの初期パスワード"
  type        = string
}
