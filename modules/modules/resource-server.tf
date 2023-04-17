#####################################################
# Variables
#####################################################
variable "resource_servers" {
  type = map(object({
    standard_flow_enabled = bool
    root_url              = string
    valid_redirect_uris   = list(string)
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
resource "keycloak_openid_client" "resource_servers" {
  for_each = var.resource_servers

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
  base_url            = lookup(each.value, "root_url", "")
  root_url            = lookup(each.value, "root_url", "")
  web_origins         = [lookup(each.value, "root_url", "")]
  admin_url           = lookup(each.value, "root_url", "")
  valid_redirect_uris = lookup(each.value, "valid_redirect_uris", [])
}

resource "keycloak_openid_client_optional_scopes" "resource_servers" {
  for_each = var.resource_servers

  realm_id  = keycloak_realm.this.id
  client_id = keycloak_openid_client.resource_servers[each.key].id

  optional_scopes = concat([
    "address",
    "phone",
    "offline_access",
    "microprofile-jwt"
  ], lookup(each.value, "optional_scopes", []))
}
