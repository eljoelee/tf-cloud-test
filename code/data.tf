data "terraform_remote_state" "tf-cloud-test" {
  backend = "remote"

  config = {
    organization = "testing-ecs"
    workspaces = {
      name = "infra"
    }
  }
}