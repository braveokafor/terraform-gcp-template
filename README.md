# Terraform GCP Template

Terraform template to bootstrap a baseline project in Google Cloud.

<!-- BEGIN_TEMPLATE_DOCUMENTATION -->
### Features
| Feature | Description | File |
|---------|-------------|----------|
| Network | Compute Engine Network | `network.tf` |
| Subnet | Subnet in the default region | `network.tf` |
| NAT Gateway | NAT Gateway with static IP in the default region | `network.tf` |
| Private Service Connector | Private connector for private Google API's access | `network.tf` |
| Serverless VPC Connector | Serverless VPC connector for Serverless workload access | `network.tf` |
| Firewalls | Baseline firewall rules | `firewall.tf` |
| Budgets | Budget alert, defaults to 100 USD | `budget.tf` |
| IAM | Assigns defined roles to IAM users across 3 levels `admin`, `dev` and `basic` | `iam.tf` |
| Services | Enables defined Google cloud API's | `services.tf` |
| Notifications | Email notification channel for budget alerts etc | `monitoring.tf` |
| CI/CD | GitHub Actions to `lint`, `plan`, and `apply` to Google Cloud | `.github/workflows/terraform-apply.yaml`, `.github/workflows/terraform-plan.yaml` |

## Usage
> **DO NOT FORK** this is meant to be used from **[Use this template](https://github.com/braveokafor/terraform-gcp-template/generate)** feature.

1. Click on **[Use this template](https://github.com/braveokafor/terraform-gcp-template/generate)**
3. Give a name to your repo
3. Wait until the first run of CI finishes  
   (Github Actions will process the template and commit to your new repo)
4. Clone your new repo.
5. Update `terraform.tfvars` and `provider.tf` with your `project` and `backend`
4. If you don't want CI/CD (GitHub Actions), delete `.github/workflows/terraform-apply.yaml` and `.github/workflows/terraform-plan.yaml`  
5. If you want CI/CD (GitHub Actions):  
  On the new repository `settings->secrets` add your `GOOGLE_SERVICE_ACCOUNT`, `GOOGLE_WORKLOAD_IDENTITY_PROVIDER` and `TERRAFORM_PLAN_BUCKET` (to store plan files).  
  To `plan`, create a `feature branch` and raise a `PR` to `main`.  
  To `apply`, merge the `PR` into `main` (note the `apply` job runs against the `feature branch`).  
  A terraform module to set up Google Cloud `workload identity` for GitHub Actions is available [here](https://github.com/braveokafor/terraform-gcp-github-actions).  


> **NOTE**: **WAIT** until first CI run on github actions before cloning your new project.
<!-- END_TEMPLATE_DOCUMENTATION -->


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.0 |

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| <a name="input_notification_emails"></a> [notification\_emails](#input\_notification\_emails) | Email addresses to send notifications to | `list(string)` | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project | `string` | yes |
| <a name="input_admin_user_roles"></a> [admin\_user\_roles](#input\_admin\_user\_roles) | Admin user roles | `list(string)` | no |
| <a name="input_admin_users"></a> [admin\_users](#input\_admin\_users) | Email address of admin users | `list(string)` | no |
| <a name="input_basic_user_roles"></a> [basic\_user\_roles](#input\_basic\_user\_roles) | Admin user roles | `list(string)` | no |
| <a name="input_basic_users"></a> [basic\_users](#input\_basic\_users) | Email address of basic users | `list(string)` | no |
| <a name="input_billing_account_id"></a> [billing\_account\_id](#input\_billing\_account\_id) | The ID of the Billing Account | `string` | no |
| <a name="input_budget_alert_thresholds"></a> [budget\_alert\_thresholds](#input\_budget\_alert\_thresholds) | What points should billing alerts be sent | `list(number)` | no |
| <a name="input_budget_currency"></a> [budget\_currency](#input\_budget\_currency) | The 3-letter currency code as defined in ISO 4217 | `string` | no |
| <a name="input_dev_user_roles"></a> [dev\_user\_roles](#input\_dev\_user\_roles) | Dev (developer) user roles | `list(string)` | no |
| <a name="input_dev_users"></a> [dev\_users](#input\_dev\_users) | Email address of dev (developer) users | `list(string)` | no |
| <a name="input_enable_budget"></a> [enable\_budget](#input\_enable\_budget) | Create a budget | `bool` | no |
| <a name="input_enable_firewall_ingress_logs"></a> [enable\_firewall\_ingress\_logs](#input\_enable\_firewall\_ingress\_logs) | Should firewall logs be enabled for ingress traffic | `bool` | no |
| <a name="input_enable_nat_logs"></a> [enable\_nat\_logs](#input\_enable\_nat\_logs) | Should Cloud NAT logs be enabled | `bool` | no |
| <a name="input_enable_subnet_flow_logs"></a> [enable\_subnet\_flow\_logs](#input\_enable\_subnet\_flow\_logs) | Should subnet flow logs be enabled | `bool` | no |
| <a name="input_enabled_apis"></a> [enabled\_apis](#input\_enabled\_apis) | Google Cloud API's to enable on the project. | `list(string)` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Common Labels | `map(string)` | no |
| <a name="input_monthly_budget"></a> [monthly\_budget](#input\_monthly\_budget) | Monthly budget | `string` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix to prepend to resource names | `string` | no |
| <a name="input_region"></a> [region](#input\_region) | Default region for resources | `string` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network"></a> [network](#output\_network) | Network name |
| <a name="output_subnet"></a> [subnet](#output\_subnet) | Subnet name |
| <a name="output_vpc_connector_subnet"></a> [vpc\_connector\_subnet](#output\_vpc\_connector\_subnet) | VPC connector subnet name |
<!-- END_TF_DOCS -->
