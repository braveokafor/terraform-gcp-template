# terraform-gcp-template

[![Plan Status][badge_plan_status]][link_plan_status]
[![Apply Status][badge_apply_status]][link_apply_status]
[![Issues][badge_issues]][link_issues]
[![Issues][badge_pulls]][link_pulls]
[![Version][badge_release_version]][link_release_version]

Terraform GCP Project Template

### Features

## Usage

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 4.0 |

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project | `string` | yes |
| <a name="input_enabled_apis"></a> [enabled\_apis](#input\_enabled\_apis) | Google Cloud API's to enable on the project. | `list(string)` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

[link_issues]: https://github.com/braveokafor/terraform-gcp-template/issues
[link_pulls]: https://github.com/braveokafor/terraform-gcp-template/pulls
[link_plan_status]: https://github.com/braveokafor/terraform-gcp-template/actions/workflows/terraform-plan.yaml
[link_apply_status]: https://github.com/braveokafor/terraform-gcp-template/actions/workflows/terraform-apply.yaml
[link_release_version]: https://github.com/braveokafor/terraform-gcp-template/releases/latest
[badge_issues]: https://img.shields.io/github/issues-raw/braveokafor/terraform-gcp-template?style=flat-square&logo=GitHub
[badge_pulls]: https://img.shields.io/github/issues-pr/braveokafor/terraform-gcp-template?style=flat-square&logo=GitHub
[badge_plan_status]: https://img.shields.io/github/actions/workflow/status/braveokafor/terraform-gcp-template/terraform-plan.yaml?style=flat-square&logo=GitHub&label=build
[badge_apply_status]: https://img.shields.io/github/actions/workflow/status/braveokafor/terraform-gcp-template/terraform-apply.yaml?style=flat-square&logo=GitHub&label=build
[badge_release_version]: https://img.shields.io/github/v/release/braveokafor/terraform-gcp-template?style=flat-square&logo=GitHub&label=version
