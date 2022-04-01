terraform {
  required_version = ">= 1.1.1"
  cloud {
    organization = "DrMagPie"
    workspaces {
      name = "RootTheBox"
    }
  }
}
