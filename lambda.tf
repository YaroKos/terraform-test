resource "aws_lambda_function" "lambda_errorprinter" {
  function_name = "${var.prefix}-${var.environment}-errorprinter"
  filename = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  role = aws_iam_role.lambda_role.arn
  handler = "errorprinter.lambda_handler"
  runtime = "python3.7"
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_errorprinter.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.eventbridge.arn
}