locals {
  default_variables_path   = "${path.cwd}/defaults.yaml"
  workspace_variables_path = "${path.cwd}/workspaces/${terraform.workspace}.yaml"

  default_variables = yamldecode(fileexists(local.default_variables_path) ?
    file(local.default_variables_path) : yamlencode({})
  )
  workspace_variables = yamldecode(fileexists(local.workspace_variables_path) ?
    file(local.workspace_variables_path) : yamlencode({})
  )

  merged_variables = merge(
    local.default_variables,
    local.workspace_variables
  )
}

output "variables" {
  value = local.merged_variables
}
