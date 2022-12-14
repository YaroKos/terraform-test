{
  "source": [ "aws.cloudwatch" ],
  "detail-type": [ "CloudWatch Alarm State Change" ],
  "resources": [ "${alarm_arn}" ],
  "detail": {
    "state": {
      "value": [ "ALARM" ]
    }
  }
}