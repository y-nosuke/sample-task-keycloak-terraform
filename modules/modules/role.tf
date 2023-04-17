#####################################################
# Variables
#####################################################
variable "realm_roles" {
  type        = map(string)
  description = "Role名と説明のMap"
}

variable "client_roles" {
  type = map(object({
    client      = string
    description = string
  }))
  description = "Client Role名と説明"
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
resource "keycloak_role" "realm_role" {
  for_each = var.realm_roles

  realm_id    = keycloak_realm.this.id
  name        = each.key
  description = each.value
}

resource "keycloak_role" "client_role" {
  for_each = var.client_roles

  realm_id    = keycloak_realm.this.id
  client_id   = keycloak_openid_client.client[lookup(each.value, "client")].id
  name        = each.key
  description = lookup(each.value, "description")
}
