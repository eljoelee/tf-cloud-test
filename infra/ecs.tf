resource "aws_ecs_cluster" "beer-cluster" {
    name = "beer-cluster"

    setting {
      name = "containerInsights"
      value = "disabled"
    }   
}

resource "aws_ecs_task_definition" "beer-task" {
    family = "beer-task"
    requires_compatibilities = [ "FARGATE" ]
    execution_role_arn = aws_iam_role.ecs-task-role.arn
    network_mode = "awsvpc"

    cpu = 256
    memory = 512
}