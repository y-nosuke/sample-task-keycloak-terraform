# sample-task-terraform-keycloak

KeyCloak の設定を行う terraform のソースです。

## 事前準備

### hosts ファイルの編集

末尾に以下を追加する

```text
127.0.0.1 keycloak.localhost
```

### adminのメールアドレス設定

<http://keycloak.localhost/admin/master/console/#/master/users>

adminのメールアドレスを設定する（例： <admin@example.com>）

### .direnv の作成

```sh
direnv edit .
export TF_VAR_client_id=admin-cli
export TF_VAR_username=(KeyCloakのユーザ名 例）admin)
export TF_VAR_password=(KeyCloakのパスワード 例）admin)
export TF_VAR_url=(KeyCloakのURL 例）http://keycloak.localhost)

export TF_VAR_user_initial_password=(ユーザの初期パスワード 例）password)
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
