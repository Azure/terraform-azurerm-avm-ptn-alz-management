provider "azurerm" {
  features {}
}

run "examples_default" {
  command = plan

  module {
    source = "./examples/default"
  }
}

run "examples_complete" {
  command = plan

  module {
    source = "./examples/complete"
  }
}

run "examples_no_automation_account" {
  command = plan

  module {
    source = "./examples/no_automation_account"
  }
}

