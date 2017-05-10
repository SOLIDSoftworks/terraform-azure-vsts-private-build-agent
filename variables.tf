variable "arm_client_id" {}
variable "arm_client_secret" {}
variable "arm_tenant_id" {}
variable "arm_subscription_id" {}

variable "location" { default = "East US" }
variable "name" { default = "buildagent"}

variable "admin_username" {}
variable "admin_password" {}

variable "vsts_user" {}
variable "vsts_agent_group" { default = "default" }
variable "vsts_personal_access_token" {}

variable "count" { default = 1}