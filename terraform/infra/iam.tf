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
        ]
    })
}

resource "aws_iam_role" "ecs-task-role" {
    name = "ECSTaskRole"
    assume_role_policy = data.aws_iam_policy_document.policy-doc-beer.json
}

data "aws_iam_policy_document" "policy-doc-beer" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs-task-role-attachment" {
    role = aws_iam_role.ecs-task-role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}