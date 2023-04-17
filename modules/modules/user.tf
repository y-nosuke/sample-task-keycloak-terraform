#####################################################
# Variables
#####################################################
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
# Resources
#####################################################
resource "keycloak_user" "this" {
  for_each = { for u in var.users : u.username => u }

  realm_id = keycloak_realm.this.id
  username = lookup(each.value, "username")
  enabled  = true

  email      = lookup(each.value, "email")
  first_name = lookup(each.value, "first_name")
  last_name  = lookup(each.value, "last_name")

  initial_password {
    value     = var.initial_password
    temporary = true
  }
}

resource "keycloak_user_roles" "this" {
  for_each = { for u in var.users : u.username => u }

  realm_id = keycloak_realm.this.id
  user_id  = keycloak_user.this[each.key].id

  role_ids = [for r in lookup(each.value, "roles") : keycloak_role.realm_role[r].id]
}
