resource "aws_ecs_cluster" "cluster_petclinic" {
  name = "${var.prefix}-${var.environment}-cluster-petclinic"
}

resource "aws_ecs_cluster_capacity_providers" "cluster_capacity" {
  cluster_name = aws_ecs_cluster.cluster_petclinic.name
  capacity_providers = [aws_ecs_capacity_provider.autoscaling_capacity.name]
}

resource "aws_ecs_capacity_provider" "autoscaling_capacity" {
  name = "${var.prefix}-${var.environment}-cluster-capacity"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.asg.arn
    managed_scaling {
      status = "DISABLED"
    }
    managed_termination_protection = "DISABLED"
  }
}

resource "aws_ecs_service" "ecs_service" {
  name = "${var.prefix}-${var.environment}-cluster-service"
  cluster = aws_ecs_cluster.cluster_petclinic.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  #scheduling_strategy = "DAEMON"
  scheduling_strategy = "REPLICA"
  force_new_deployment = true
  desired_count = var.ecs_service_desired_size
  health_check_grace_period_seconds = 120

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name = "${var.prefix}-${var.environment}-container"
    container_port = 8080
  }

  depends_on = [aws_lb_listener.listener, aws_iam_role.role]
}

resource "aws_ecs_task_definition" "task_definition" {
  family = "${var.prefix}-${var.environment}-task"
  container_definitions = data.template_file.definition.rendered
  execution_role_arn = aws_iam_role.role.arn
  task_role_arn = aws_iam_role.role.arn
}