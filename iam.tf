locals {
  admin_user_roles = flatten([
    for user in var.dev_users :
    [
      for role in var.dev_user_roles :
      {
        principal = user
        role      = role
      }
    ]
  ])

  dev_user_roles = flatten([
    for user in var.dev_users :
    [
      for role in var.dev_user_roles :
      {
        principal = user
        role      = role
      }
    ]
  ])

  basic_user_roles = flatten([
    for user in var.dev_users :
    [
      for role in var.dev_user_roles :
      {
        principal = user
        role      = role
      }
    ]
  ])
}

resource "google_project_iam_member" "admin_users" {
  for_each = { for pair in local.admin_user_roles : format("%s<=>%s", split("@", pair.user)[0], split("/", pair.role)[1]) => pair }

  project = var.project_id
  role    = each.value.role
  member  = each.value.user
}

resource "google_project_iam_member" "dev_users" {
  for_each = { for pair in local.dev_user_roles : format("%s<=>%s", split("@", pair.user)[0], split("/", pair.role)[1]) => pair }

  project = var.project_id
  role    = each.value.role
  member  = each.value.user
}

resource "google_project_iam_member" "basic_users" {
  for_each = { for pair in local.basic_user_roles : format("%s<=>%s", split("@", pair.user)[0], split("/", pair.role)[1]) => pair }

  project = var.project_id
  role    = each.value.role
  member  = each.value.user
}
