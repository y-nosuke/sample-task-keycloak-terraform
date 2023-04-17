#####################################################
# Variables
#####################################################
variable "client_scopes" {
  type        = list(string)
  description = "Client Scopseのリスト"
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
resource "keycloak_openid_client_scope" "this" {
  for_each = toset(var.client_scopes)

  realm_id               = keycloak_realm.this.id
  name                   = each.key
  description            = each.key
  include_in_token_scope = true
  gui_order              = 1
}
