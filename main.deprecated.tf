# Remove this once migration to sentinel onboardingstates API is complete
moved {
  from = azurerm_log_analytics_solution.management["Microsoft/OMSGallery/SecurityInsights"]
  to   = azurerm_log_analytics_solution.security_insights_remove_legacy_deployment_from_state_but_do_not_destroy
}

# Remove this once migration to sentinel onboardingstates API is complete
removed {
  from = azurerm_log_analytics_solution.security_insights_remove_legacy_deployment_from_state_but_do_not_destroy
  lifecycle {
    destroy = false
  }
}
