resource "aws_codebuild_project" "codebuild-beer-api" {
    name = "beer-api"
    build_timeout = "20"
    service_role = aws_iam_role.codebuild-service-role.arn

    artifacts {
        type = "CODEPIPELINE"
    }

    cache {
        type = "S3"
        location = data.terraform_remote_state.tf-cloud-test.outputs.s3_bucket
    }

    source {
        type = "CODEPIPELINE"
        buildspec = "buildspec.yml"
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