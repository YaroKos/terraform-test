resource "aws_autoscaling_group" "asg" {
  name = "${var.prefix}-${var.environment}-autoscaling-group"
  desired_capacity = var.asg_desired_size
  min_size = var.asg_min_size
  max_size = var.asg_max_size
  termination_policies = ["OldestInstance"]
  vpc_zone_identifier = data.aws_subnets.subnets.ids
  target_group_arns = [aws_lb_target_group.target_group.arn]
  health_check_type = "EC2"

  launch_template {
    id = aws_launch_template.template.id
    version = "$Latest"
  }

  tag {
    key = "AmazonECSManaged"
    value = true
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "template" {
  name = "${var.prefix}-${var.environment}-launch-template-for-asg"
  image_id = var.image_id
  instance_type = var.instance_type
  key_name = var.key_pair_name

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination = true
    security_groups = [aws_security_group.instance_sg.id]
  }
  
  block_device_mappings {
    device_name = var.block_device_name

    ebs {
      volume_size = var.disk_size
      volume_type = var.disk_type
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.profile.arn
  }

  monitoring {
    enabled = true
  }

  metadata_options {
    http_endpoint = "enabled"
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
        Name = "${var.prefix}-${var.environment}-instance from asg"
        Source = "Autoscaling"
    }
  }

  user_data = "${base64encode(data.template_file.userdata.rendered)}"
}

resource "aws_security_group" "instance_sg" {
  name = "${var.prefix}-${var.environment}-allow-dynamic-ecs"
  description = "security group for ecs"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port = 32768
    protocol = "tcp"
    to_port = 65535
    security_groups = ["${aws_security_group.service_sg.id}"]
  }

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [var.ip_whitelist]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}