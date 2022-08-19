resource "aws_iam_policy" "ecr-for-build" {
    name = "AccessECRForCodeBuild"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "ecr:BatchCheckLayerAvailability",
	                "ecr:CompleteLayerUpload",
	                "ecr:GetAuthorizationToken",
	                "ecr:InitiateLayerUpload",
	                "ecr:PutImage",
	                "ecr:UploadLayerPart"
                ]
                Resource = "*",
                Effect = "Allow"
            },
            {
                Action = [
                    "s3:GetObject", 
                    "s3:GetObjectVersion", 
                    "s3:PutObject"
                ]
                Resource = "${data.terraform_remote_state.tf-cloud-test.outputs.s3_arn}/*"
                Effect = "Allow"
            },
            {
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ]
                Resource = "*"
                Effect = "Allow"
            }
        ]
    })
}

resource "aws_iam_role" "codebuild-service-role" {
    name = "CodeBuildServiceRole"
    assume_role_policy = data.aws_iam_policy_document.policy-doc-codebuild.json
}

data "aws_iam_policy_document" "policy-doc-codebuild" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "codebuild-service-role-attachment" {
    role = aws_iam_role.codebuild-service-role.name
    policy_arn = aws_iam_policy.ecr-for-build.arn
}