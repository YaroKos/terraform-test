resource "aws_cloudwatch_event_rule" "eventbridge" {
  name        = "${var.prefix}-${var.environment}-eventbridge-rule"
  description = "Triggered by CloudWatch Alarm State Change"
  event_pattern = data.template_file.eventpattern.rendered
}

resource "aws_cloudwatch_event_target" "trigger_lambda" {
  rule = aws_cloudwatch_event_rule.eventbridge.name
  arn  = aws_lambda_function.lambda_errorprinter.arn
}