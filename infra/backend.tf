terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "testing-ecs"

    workspaces {
      name = "infra"
    }
  }
}