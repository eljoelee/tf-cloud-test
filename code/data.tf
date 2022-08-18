data "terraform_remote_state" "tf-cloud-test" {
  backend = "remote"

  config = {
    organization = "testing-ecs"
    workspaces = {
      name = "tf-cloud-test"
    }
  }
}

data "aws_ecr_repositroy" "beer-api" {
    name = "beer-api"
}