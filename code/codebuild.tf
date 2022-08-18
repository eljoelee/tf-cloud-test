resource "aws_codebuild_project" "codebuild-beer-api" {
    name = "beer-api"
    build_timeout = "5"
    service_role = aws_iam_role.codebuild-service-role.arn

    aritifacts {
        type = "NO_ARTIFACTS"
    }

    source {
        type = "CODECOMMIT"
        buildspec = "buildspec.yml"
        loaction = var.repo_name
        git_clone_depth = 0
    }

    environment {
        image = "aws/codebuild/standard:6.0"    # Ubuntu
        type = "LINUX_CONTAINER"                # 환경 유형
        compute_type = "BUILD_GENERAL1_SMALL"   # 추가 구성 > 컴퓨팅
        privileged_mode = true

        environment_variable {
            name = "AWS_DEFAULT_REGION"
            value = var.region
        }

        environment_variable {
            name = "AWS_ACCOUNT_ID"
            value = var.account_id
        }

        environment_variable {
            name = "IMAGE_REPO_NAME"
            value = var.container_repo_name
        }

        environment_variable {
            name = "IMAGE_TAG"
            value = var.image_tag_name
        }
    }
}