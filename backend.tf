terraform {
  required_version = ">= 1.3.7"
  cloud {
    organization = "DrMagPie"
    workspaces {
      name = "RootTheBox"
    }
  }
}
