locals {
  defaults_variables_path  = "${path.cwd}/defaults.yaml"
  workspace_variables_path = "${path.cwd}/workspaces/${terraform.workspace}.yaml"
  defaults_variables = yamldecode(fileexists(local.defaults_variables_path) ?
    file(local.defaults_variables_path) : yamlencode({})
  )
  workspace_variables = yamldecode(fileexists(local.workspace_variables_path) ?
    file(local.workspace_variables_path): yamlencode({})
  )
  merged_variables = merge(
    local.defaults_variables,
    local.workspace_variables
  )
}

output "variables" {
  value = local.merged_variables
}
