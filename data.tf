data "aws_iam_policy_document" "assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "inline_policy" {
  statement {
    actions = [
      "ec2:DescribeTags",
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:UpdateContainerInstancesState",
      "ecs:Submit*",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

data "aws_subnets" "subnets" {
  filter {
    name = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

data "template_file" "userdata" {
  template = "${file("userdata.tpl")}"

  vars = {
    ecs_cluster = "${aws_ecs_cluster.cluster_petclinic.name}"
  }
}

data "template_file" "definition" {
  template = "${file("definition.tpl")}"

  vars = {
    prefix = "${var.prefix}"
    environment = "${var.environment}"
    cloudwatch_log_group = "${aws_cloudwatch_log_group.log-group.id}"
    db_address = "${aws_db_instance.rds_petclinic.address}"
    db_name = "${var.db_name}"
    db_username = "${var.db_username}"
    db_password = "${var.db_password}"
  }
}

data "template_file" "eventpattern" {
  template = "${file("eventpattern.tpl")}"

  vars = {
    alarm_arn = "${aws_cloudwatch_metric_alarm.ecs_cpu_alarm.arn}"
  }
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_inline_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "errorprinter.py"
  output_path = "errorprinter.zip"
}