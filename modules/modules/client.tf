#####################################################
# Variables
#####################################################
variable "clients" {
  type = map(object({
    client_service_account_role = string
    standard_flow_enabled       = bool
    optional_scopes             = list(string)
  }))
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
resource "keycloak_openid_client" "client" {
  for_each = var.clients

  realm_id  = keycloak_realm.this.id
  client_id = each.key

  name    = each.key
  enabled = true

  access_type                  = "CONFIDENTIAL"
  standard_flow_enabled        = lookup(each.value, "standard_flow_enabled")
  direct_access_grants_enabled = true
  service_accounts_enabled     = true
  authorization {
    policy_enforcement_mode = "ENFORCING"
  }
}

resource "keycloak_openid_client_service_account_role" "client" {
  for_each = var.clients

  realm_id                = keycloak_realm.this.id
  service_account_user_id = keycloak_openid_client.client[each.key].service_account_user_id
  client_id               = keycloak_openid_client.client[each.key].id
  role                    = lookup(each.value, "client_service_account_role")

  depends_on = [
    keycloak_role.client_role
  ]
}

resource "keycloak_openid_client_optional_scopes" "client" {
  for_each = var.clients

  realm_id  = keycloak_realm.this.id
  client_id = keycloak_openid_client.client[each.key].id

  optional_scopes = concat([
    "address",
    "phone",
    "offline_access",
    "microprofile-jwt",
    "audience",
  ], lookup(each.value, "optional_scopes", []))
}
