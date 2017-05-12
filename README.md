# Private vsts linux build agent in Azure
This is a terraform script for creating and provisioning a private build server to be used on [vsts](https://www.visualstudio.com/)

## Example

    module "build-agent" {
      source = "github.com/SOLIDSoftworks/terraform-azure-vsts-private-build-agent"

      arm_client_id         = "..."
      arm_client_secret     = "..."
      arm_tenant_id         = "..."
      arm_subscription_id   = "..."

      admin_username        = "..."
      admin_password        = "..."

      vsts_user                  = "..."
      vsts_personal_access_token = "..."
    }

## Variables
### Required
**arm_client_id**: This is equivalent to **client_id** in the Terraform documentation for the [Azure Resource Manager provider](https://www.terraform.io/docs/providers/azurerm/index.html#argument-reference).

**arm_client_secret**: This is equivalent to **client_secret** in the Terraform documentation for the [Azure Resource Manager provider](https://www.terraform.io/docs/providers/azurerm/index.html#argument-reference).

**arm_tenant_id**: This is equivalent to **tenant_id** in the Terraform documentation for the [Azure Resource Manager provider](https://www.terraform.io/docs/providers/azurerm/index.html#argument-reference).  

**arm_subscription_id**: This is equivalent to **subscription_id** in the Terraform documentation for the [Azure Resource Manager provider](https://www.terraform.io/docs/providers/azurerm/index.html#argument-reference).  

**admin_username**: This is the admin username for the build agent.

**admin_password**: This is the admin password for the build agent.

**vsts_user**: This is your user on [vsts](https://www.visualstudio.com/).

**vsts_personal_access_token**: This is a personal access token that you can create on [vsts](https://www.visualstudio.com/). Documentation on this can be found on [visualstudio.com](https://www.visualstudio.com/en-us/docs/setup-admin/team-services/use-personal-access-tokens-to-authenticate)

### Optional
**count**: This is the amount of build agents you want to create. Defaults to **1**.

**name**: This is the name of the build agent. Defaults to **buildagent**.

**location**: This is the location of the build agent on Azure. Defaults to **East US**. _Be aware that changing this might break the terraform plan since the VM size is always set to Standard_DS1_v2. This should be set as a variable later._

**vsts_agent_group**: Sets what group the agent should be put into. Defaults to **default**