resource "aws_iam_role" "ecs-task-role" {
    name = "ECSTaskRole"
    assume_role_policy = data.aws_iam_policy_document.policy-doc-ecs.json
}

data "aws_iam_policy_document" "policy-doc-ecs" {
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