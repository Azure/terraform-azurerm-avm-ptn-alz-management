locals {
  user_assigned_managed_identities = merge(local.user_assigned_managed_identity_ama)
  user_assigned_managed_identity_ama = var.user_assigned_managed_identities.ama.enabled ? {
    ama = {
      name     = var.user_assigned_managed_identities.ama.name
      location = var.user_assigned_managed_identities.ama.location == null ? var.location : var.user_assigned_managed_identities.ama.location
      tags     = var.user_assigned_managed_identities.ama.tags == null ? var.tags : var.user_assigned_managed_identities.ama.tags
    }
  } : {}
}
