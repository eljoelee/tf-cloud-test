resource "aws_codepipeline" "beer-pipeline" {
    name = "beer-api"
    role_arn = aws_iam_role.codepipeline-service-role.arn
    
    artifact_store {
        type = "S3"
        location = data.terraform_remote_state.tf-cloud-test.outputs.s3_bucket
    }

    stage {
        name = "Source"
        action {
            name = "Source"
            category = "Source"
            owner = "AWS"
            version = "1"
            provider = "CodeCommit"
            output_artifacts = ["source_output"]

            configuration = {
                RepositoryName = "beer-api"
                BranchName     = "master"
            }
        }
    }

    stage {
        name = "Build"
        action {
            name = "Build"
            category = "Build"
            owner = "AWS"
            version = "1"
            provider = "CodeBuild"
            input_artifacts  = ["source_output"]
            output_artifacts = ["build_output"]
            run_order = 1
            configuration = {
                ProjectName = aws_codebuild_project.codebuild-beer-api.id
            }
        }
    }
}