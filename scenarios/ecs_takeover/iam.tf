//
// ECS Worker Instance Role
//
data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_agent" {
  name               = "ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}


resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = aws_iam_role.ecs_agent.name
}



//
//  ECS Container role
//

data "aws_iam_policy_document" "ecs_tasks_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}



resource "aws_iam_role" "containerRole" {
  name                = "containerRole"
  assume_role_policy  = data.aws_iam_policy_document.ecs_tasks_role.json 
  managed_policy_arns = [aws_iam_policy.policy_two.arn]
}


resource "aws_iam_policy" "policy_two" {
  name = "policy-381966"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
              "ecs:ListServices",
              "ecs:ListTasks",
              "ecs:DescribeServices",
              "ecs:ListContainerInstances",
              "ecs:DescribeContainerInstances",
              "ecs:DescribeTasks",
              "ecs:ListTaskDefinitions",
              "ecs:DescribeClusters",
              "ecs:ListClusters"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}