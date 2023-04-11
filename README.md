# About

Terraform for [bluesky-social/atproto](https://github.com/bluesky-social/atproto) in aws

---

## Requirements

- AWS cli and SSO login
- A domain registered
- Moving out of the AWS SES sandbox
- Create DID in PLC server (detailed at [tips](#Tips))

| Name                                                   | Version |
| ------------------------------------------------------ | ------- |
| <a name="requirement_aws"></a> [aws](#requirement_aws) | ~> 4.0  |

## Recommend

- Setup AWS Organization and SSO login

## Providers

| Name                                                                        | Version |
| --------------------------------------------------------------------------- | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws)                            | 4.58.0  |
| <a name="provider_aws.virginia"></a> [aws.virginia](#provider_aws.virginia) | 4.58.0  |
| <a name="provider_template"></a> [template](#provider_template)             | 2.2.0   |

## Modules

No modules.

---

## Usage

1. Fork this repo.
2. Exec `cp terraform.tfvars.example terraform.tfvars`
3. Input values of `terraform.tfvars`
4. Exec `terraform plan`, if no problem, Exec `terraform apply`

## Inputs

| Name                                                                                                                        | Description                                           | Type     | Default                            | Required |
| --------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------- | -------- | ---------------------------------- | :------: |
| <a name="input_admin_password"></a> [admin_password](#input_admin_password)                                                 | 管理者パスワード                                      | `string` | n/a                                |   yes    |
| <a name="input_atproto_pds_container_repo_url"></a> [atproto_pds_container_repo_url](#input_atproto_pds_container_repo_url) | PDS のコンテナの URL                                  | `string` | `"docker.io/kingyosun/atproto"`    |    no    |
| <a name="input_atproto_pds_container_tag"></a> [atproto_pds_container_tag](#input_atproto_pds_container_tag)                | PDS のコンテナのタグ                                  | `string` | `"latest"`                         |    no    |
| <a name="input_available_user_domains"></a> [available_user_domains](#input_available_user_domains)                         | ,区切りで複数定義できる, ユーザーが利用可能なドメイン | `string` | `".test,.dev.bsky.dev"`            |    no    |
| <a name="input_aws_account_id"></a> [aws_account_id](#input_aws_account_id)                                                 | AWS アカウント ID                                     | `string` | n/a                                |   yes    |
| <a name="input_aws_region"></a> [aws_region](#input_aws_region)                                                             | aws region                                            | `string` | `"ap-northeast-1"`                 |    no    |
| <a name="input_aws_sso_role"></a> [aws_sso_role](#input_aws_sso_role)                                                       | AWS の SSO Admin ロール                               | `string` | n/a                                |   yes    |
| <a name="input_database_name"></a> [database_name](#input_database_name)                                                    | DB 名                                                 | `string` | `"atproto_pds"`                    |    no    |
| <a name="input_database_password"></a> [database_password](#input_database_password)                                        | DB の PASSWORD                                        | `string` | `"chinpokopon"`                    |    no    |
| <a name="input_database_username"></a> [database_username](#input_database_username)                                        | DB の USERNAME                                        | `string` | `"admin"`                          |    no    |
| <a name="input_did_plc_server_url"></a> [did_plc_server_url](#input_did_plc_server_url)                                     | PLC サーバーの URL                                    | `string` | `"https://plc.directory"`          |    no    |
| <a name="input_ecs_log_retention_in_days"></a> [ecs_log_retention_in_days](#input_ecs_log_retention_in_days)                | ECS のログ保持日数                                    | `number` | `90`                               |    no    |
| <a name="input_host_domain"></a> [host_domain](#input_host_domain)                                                          | PDS のドメイン                                        | `string` | `"localhost"`                      |    no    |
| <a name="input_invite_required"></a> [invite_required](#input_invite_required)                                              | 招待コードが必要な場合 true                           | `string` | `"true"`                           |    no    |
| <a name="input_user_invite_interval"></a> [user_invite_interval](#input_user_invite_interval)                               | 招待コードの発行間隔                                  | `number` | `604800000`                        |    no    |
| <a name="input_jwt_secret"></a> [jwt_secret](#input_jwt_secret)                                                             | n/a                                                   | `string` | n/a                                |   yes    |
| <a name="input_kms_recovery_key_alias"></a> [kms_recovery_key_alias](#input_kms_recovery_key_alias)                         | KMS の recovery_key の alias                          | `string` | `"alias/atproto/pds/recovery_key"` |    no    |
| <a name="input_kms_signing_key_alias"></a> [kms_signing_key_alias](#input_kms_signing_key_alias)                            | KMS の signing_key の alias                           | `string` | `"alias/atproto/pds/signing_key"`  |    no    |
| <a name="input_log_level"></a> [log_level](#input_log_level)                                                                | pino の Log Level                                     | `string` | `"info"`                           |    no    |
| <a name="input_pds_version"></a> [pds_version](#input_pds_version)                                                          | PDS コンテナの version                                | `string` | `"0.0.0"`                          |    no    |
| <a name="input_repo_signing_key"></a> [repo_signing_key](#input_repo_signing_key)                                           | repository signing key(raw)                           | `string` | n/a                                |   yes    |
| <a name="input_s3_bucket_name"></a> [s3_bucket_name](#input_s3_bucket_name)                                                 | S3 のバケット名                                       | `string` | `"atproto-pds"`                    |    no    |
| <a name="input_server_did"></a> [server_did](#input_server_did)                                                             | 鯖缶 Did? 事前に plc サーバーで作成する               | `string` | n/a                                |   yes    |
| <a name="input_ses_smtp_key_id"></a> [ses_smtp_key_id](#input_ses_smtp_key_id)                                              | SMTP サーバーの Access Key                            | `string` | n/a                                |   yes    |
| <a name="input_ses_smtp_password_v4"></a> [ses_smtp_password_v4](#input_ses_smtp_password_v4)                               | SMTP サーバーの Password v4                           | `string` | n/a                                |   yes    |
| <a name="input_ssm_parameter_store_base"></a> [ssm_parameter_store_base](#input_ssm_parameter_store_base)                   | SSM パラメータの基準となるパス                        | `string` | `"/atproto/pds"`                   |    no    |

## Outputs

| Name                                                                                                        | Description |
| ----------------------------------------------------------------------------------------------------------- | ----------- |
| <a name="output_aws_iam_access_key_smtp"></a> [aws_iam_access_key_smtp](#output_aws_iam_access_key_smtp)    | n/a         |
| <a name="output_aws_iam_secret_smtp"></a> [aws_iam_secret_smtp](#output_aws_iam_secret_smtp)                | n/a         |
| <a name="output_aws_iam_smtp_password_v4"></a> [aws_iam_smtp_password_v4](#output_aws_iam_smtp_password_v4) | n/a         |

---

# Tips

## create repo_signging_key

```
$ openssl ecparam -genkey -name secp256k1 -out repo_signing_key.pem
$ openssl ec -in repo_signing_key.pem -text -noout
```

## Create DID in https://plc.directory

[My MEMO in 日本語](https://scrapbox.io/Bluesky/PDS%E3%82%92AWS%E3%81%AB%E7%AB%8B%E3%81%A6%E3%81%A6%E3%81%BF%E3%82%8B)

**_ I need more efficient method! _**

1. Fork [bluesky-social/atproto](https://github.com/bluesky-social/atproto)
2. Add below code below `const keypair = await crypto.EcdsaKeypair.create()` of `/packages/dev-env/src/index.ts`. Filling `ADMIN_USER_NAME` and `DOMAIN`. (need `import * as cbor from '@ipld/dag-cbor'` and `import * as uint8arrays from 'uint8arrays'`)

```
 const keyDid = keypair.did()
 console.log(`signingKey: ${keyDid}`)
 console.log(`recoveryKey: ${keyDid}`)
 const obj = {
   type: 'create',
   signingKey: keyDid,
   recoveryKey: keyDid,
   handle: '${ADMIN_USER_NAME}.${DOMAIN}',
   service: 'https://${DOMAIN}',
   prev: null,
 }
 const data = new Uint8Array(cbor.encode(obj))
 console.log(
   `sig: ${uint8arrays.toString(await keypair.sign(data), 'base64url')}`,
 )
```

3. Exec `make build` and `make run-dev-env`, you can see `signingKey`, `recoveryKey`, `sig`
4. Exec `curl -X POST -H "Content-Type: application/json" -d '{"type":"create","signingKey":"${signingKey}","recoveryKey":"${recoveryKey}","handle":"${handle}","service":"${domain}","prev":null,"sig":"${sig}"} https://plc.directory/did:plc:${random_string}`
5. Then, you will get message `Hash of genesis operation does not match DID identifier: did:plc:${DID_HASH}`
6. Assign DID_HASH to `ramdom_string` of 4. , and redone.
7. Complete creating DID of `did:plc:${DID_HASH}` in `https://plc.directory`

---

## Resources

| Name                                                                                                                                                                                  | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_acm_certificate.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate)                                                        | resource    |
| [aws_acm_certificate.atproto_pds_cloudfront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate)                                             | resource    |
| [aws_acm_certificate_validation.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation)                                  | resource    |
| [aws_acm_certificate_validation.atproto_pds_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation)                                | resource    |
| [aws_cloudfront_distribution.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution)                                        | resource    |
| [aws_cloudwatch_log_group.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group)                                              | resource    |
| [aws_db_subnet_group.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group)                                                        | resource    |
| [aws_ecs_cluster.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster)                                                                | resource    |
| [aws_ecs_cluster_capacity_providers.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers)                          | resource    |
| [aws_ecs_service.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service)                                                                | resource    |
| [aws_ecs_task_definition.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition)                                                | resource    |
| [aws_iam_access_key.atproto_pds_ses_smtp_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key)                                             | resource    |
| [aws_iam_role.atproto_pds_fargate-task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                                         | resource    |
| [aws_iam_role.atproto_pds_fargate-task-execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                               | resource    |
| [aws_iam_role_policy.atproto_pds_fargate-task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy)                                           | resource    |
| [aws_iam_role_policy.atproto_pds_fargate-task-execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy)                                 | resource    |
| [aws_iam_role_policy_attachment.atproto_pds_AmazonECSTaskExecutionRolePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_iam_role_policy_attachment.atproto_pds_AmazonSSMReadOnlyAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)          | resource    |
| [aws_iam_user.atproto_pds_ses_smtp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user)                                                             | resource    |
| [aws_iam_user_policy.atproto_pds_ses_smtp_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy)                                          | resource    |
| [aws_internet_gateway.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)                                                      | resource    |
| [aws_kms_alias.atproto_pds_recovery_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias)                                                       | resource    |
| [aws_kms_alias.atproto_pds_signing_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias)                                                        | resource    |
| [aws_kms_key.atproto_pds_recovery_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)                                                           | resource    |
| [aws_kms_key.atproto_pds_signing_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)                                                            | resource    |
| [aws_lb.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb)                                                                                  | resource    |
| [aws_lb_listener.atproto_pds_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener)                                                           | resource    |
| [aws_lb_listener.atproto_pds_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener)                                                          | resource    |
| [aws_lb_listener_rule.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule)                                                      | resource    |
| [aws_lb_target_group.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group)                                                        | resource    |
| [aws_rds_cluster.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster)                                                                | resource    |
| [aws_rds_cluster_instance.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance)                                              | resource    |
| [aws_rds_cluster_parameter_group.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group)                                | resource    |
| [aws_route53_record.atproto_pds_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record)                                                        | resource    |
| [aws_route53_record.atproto_pds_cert_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record)                                          | resource    |
| [aws_route53_record.atproto_pds_cloudfront_cert_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record)                               | resource    |
| [aws_route53_record.atproto_pds_cname_dkim](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record)                                               | resource    |
| [aws_route53_record.atproto_pds_mx_mail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record)                                                  | resource    |
| [aws_route53_record.atproto_pds_txt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record)                                                      | resource    |
| [aws_route53_record.atproto_pds_txt_dmarc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record)                                                | resource    |
| [aws_route53_record.atproto_pds_txt_mail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record)                                                 | resource    |
| [aws_route53_zone.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone)                                                              | resource    |
| [aws_route_table.atproto_pds_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                                                         | resource    |
| [aws_route_table_association.atproto_pds_public_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)                               | resource    |
| [aws_route_table_association.atproto_pds_public_c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)                               | resource    |
| [aws_route_table_association.atproto_pds_public_d](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)                               | resource    |
| [aws_s3_bucket.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)                                                                    | resource    |
| [aws_s3_bucket.atproto_pds_alb_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)                                                            | resource    |
| [aws_s3_bucket_acl.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl)                                                            | resource    |
| [aws_s3_bucket_lifecycle_configuration.atproto_pds_alb_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration)            | resource    |
| [aws_s3_bucket_policy.atproto_pds_alb_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy)                                              | resource    |
| [aws_s3_bucket_public_access_block.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block)                            | resource    |
| [aws_s3_bucket_versioning.static](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning)                                                   | resource    |
| [aws_security_group.atproto_pds_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                                      | resource    |
| [aws_security_group.atproto_pds_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                                      | resource    |
| [aws_security_group.atproto_pds_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                                       | resource    |
| [aws_security_group_rule.atproto_pds_app_from_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)                                   | resource    |
| [aws_security_group_rule.atproto_pds_app_from_any](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)                                   | resource    |
| [aws_security_group_rule.atproto_pds_app_from_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)                                  | resource    |
| [aws_security_group_rule.atproto_pds_db_from_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)                                    | resource    |
| [aws_ses_domain_dkim.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_dkim)                                                        | resource    |
| [aws_ses_domain_identity.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_identity)                                                | resource    |
| [aws_ses_domain_mail_from.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_mail_from)                                              | resource    |
| [aws_ssm_parameter.atproto_pds_admin_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter)                                             | resource    |
| [aws_ssm_parameter.atproto_pds_database_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter)                                              | resource    |
| [aws_ssm_parameter.atproto_pds_database_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter)                                          | resource    |
| [aws_ssm_parameter.atproto_pds_database_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter)                                               | resource    |
| [aws_ssm_parameter.atproto_pds_database_username](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter)                                          | resource    |
| [aws_ssm_parameter.atproto_pds_jwt_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter)                                                 | resource    |
| [aws_subnet.atproto_pds_private_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                                | resource    |
| [aws_subnet.atproto_pds_private_c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                                | resource    |
| [aws_subnet.atproto_pds_private_d](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                                | resource    |
| [aws_subnet.atproto_pds_public_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                                 | resource    |
| [aws_subnet.atproto_pds_public_c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                                 | resource    |
| [aws_subnet.atproto_pds_public_d](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                                 | resource    |
| [aws_vpc.atproto_pds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)                                                                                | resource    |
| [aws_iam_policy_document.atproto_pds_alb_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                                     | data source |
| [template_file.atproto_pds_container_definitions](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file)                                           | data source |
| [template_file.atproto_pds_fargate-task](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file)                                                    | data source |
| [template_file.atproto_pds_fargate-task-execution](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file)                                          | data source |
| [template_file.atproto_pds_kms_key_policy](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file)                                                  | data source |
