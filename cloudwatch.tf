resource "aws_cloudwatch_log_group" "log-group" {
  name = "${var.prefix}-${var.environment}-petclinic-logs"
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.lambda_errorprinter.function_name}"
  retention_in_days = 5
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_alarm" {
  alarm_name = "${var.prefix}-${var.environment}-ecs-cpu-alarm"
  alarm_description = "This metric monitors ecs cpu utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/ECS"
  threshold = "${var.alarm_threshold}"
  period = "60"
  statistic = "Average"

  dimensions = {
    ClusterName = aws_ecs_cluster.cluster_petclinic.name
  }
}