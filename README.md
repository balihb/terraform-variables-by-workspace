# terraform-variables-by-workspace

The main goal of the module is to make the terraform code applicable to multiple
workspaces without the need to define the `.tfvar` file for the certain workspace.

Instead, it uses yaml files to define the variables.
The variables are workspace specific, and cannot be calculated values.

Typical use is to have different config for different cloud regions.

To read more about terraform workspaces:
https://www.terraform.io/docs/state/workspaces.html

## Example Usage

Let's say we want to use our infra config in AWS in multiple regions,
so we will use aws regions as workspace names.
We will use `us-west-1` and `eu-central-1` as an example.

### Workspaces directory

Create a `workspaces` directory.
Create the following two files in it.

`us-west-1.yaml`
```yaml
---
region: us-west-1
instance_names: 
  - my-us-instance-1
  - my-us-instance-2
```

`eu-central-1.yaml`
```yaml
---
region: eu-central-1
instance_names: 
  - my-eu-instance-1
  - my-eu-instance-2
```

### Create workspaces

`terraform workspace new us-west-1`

`terraform workspace new eu-central-1`

### Use the module

```terraform
module "ws_vars" {
  source = "git::https://github.com/balihb/terraform-variables-by-workspace.git?ref=tags/v1.0.1"
}

provider "aws" {
  region = lookup(module.ws_vars.variables, "region")
  # change it to the following if you want to import existing resources (or in general):
  # region = terraform.workspace
}

resource "aws_instance" "web" {
  for_each = lookup(module.ws_vars.variables, "instance_names")

  # some config omitted

  tags = {
    Name = each.value
  }
}
```

### Defaults

It is also possible to place a `defaults.yaml` file in the root of the terraform infra definition directory,
in case some variables are the same in most workspaces,
but not all (so the certain variables don't have to be defined in every file). 
