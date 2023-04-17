# sample-task-terraform-keycloak

KeyCloak の設定を行う terraform のソースです。

## 事前準備

### .direnv の作成

```sh
direnv edit .
export TF_VAR_client_id=admin-cli
export TF_VAR_username=(KeyCloakのユーザ名 例）admin)
export TF_VAR_password=(KeyCloakのパスワード 例）admin)
export TF_VAR_url=(KeyCloakのURL 例）http://localhost:8080)

export TF_VAR_keycloak_user_initial_password=(ユーザ作成時の初期パスワード)
```

### terraform の初期化

```sh
rm -rf .terraform
terraform init
```

## 実行

```sh
# リソース作成
terraform apply -var-file users.tfvars

# リソース削除
terraform destroy
```

## 参考

- [Keycloak Provider](https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs)
