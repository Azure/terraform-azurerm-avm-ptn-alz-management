# Remove this once migration to sentinel onboardingstates API is complete
moved {
  from = azurerm_log_analytics_solution.management["Microsoft/OMSGallery/SecurityInsights"]
  to   = azurerm_log_analytics_solution.security_insights_for_removal
}

# Remove this once migration to sentinel onboardingstates API is complete
removed {
  from = azurerm_log_analytics_solution.security_insights_for_removal
  lifecycle {
    destroy = false
  }
}
