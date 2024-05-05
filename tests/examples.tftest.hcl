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

