#####################################################
# Variables
#####################################################
variable "role_scope_mappings" {
  type = map(list(string))
}

variable "client_role_scope_mappings" {
  type = map(list(string))
}

#####################################################
# Locals
#####################################################
locals {
  role_scope_mappings = flatten([
    for k, v in var.role_scope_mappings : [
      for s in v : { role = k, scope = s }
    ]
  ])

  client_role_scope_mappings = flatten([
    for k, v in var.client_role_scope_mappings : [
      for s in v : { role = k, scope = s }
    ]
  ])
}

#####################################################
# Outputs
#####################################################

#####################################################
# Resources
#####################################################
resource "keycloak_generic_role_mapper" "role_scope_mapping" {
  for_each = { for m in local.role_scope_mappings : "${m.role}-${m.scope}" => m }

  realm_id        = keycloak_realm.this.id
  client_scope_id = keycloak_openid_client_scope.this[lookup(each.value, "scope")].id
  role_id         = keycloak_role.realm_role[lookup(each.value, "role")].id
}

resource "keycloak_generic_role_mapper" "client_role_scope_mapping" {
  for_each = { for m in local.client_role_scope_mappings : "${m.role}-${m.scope}" => m }

  realm_id        = keycloak_realm.this.id
  client_scope_id = keycloak_openid_client_scope.this[lookup(each.value, "scope")].id
  role_id         = keycloak_role.client_role[lookup(each.value, "role")].id
}
