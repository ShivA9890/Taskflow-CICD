resource "aws_sqs_queue" "notify" {
  name                       = "taskflow_notify"
  visibility_timeout_seconds = 60
}

resource "aws_sqs_queue" "activity" {
  name                       = "taskflow_activity"
  visibility_timeout_seconds = 60
}

resource "aws_sns_topic_subscription" "notify_sub" {
  topic_arn = aws_sns_topic.events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.notify.arn

  raw_message_delivery = true
}

resource "aws_sns_topic_subscription" "activity" {
  topic_arn = aws_sns_topic.events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.activity.arn

  raw_message_delivery = true
}

resource "aws_sqs_queue_policy" "notify_policy" {
  queue_url = aws_sqs_queue.notify.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "sns.amazonaws.com" }
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.notify.arn
        Condition = {
          ArnEquals = { "aws:SourceArn" = aws_sns_topic.events.arn }
        }
      }
    ]
  })

}

resource "aws_sqs_queue_policy" "activity_policy" {
  queue_url = aws_sqs_queue.activity.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "sns.amazonaws.com" }
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.activity.arn
        Condition = {
          ArnEquals = { "aws:SourceArn" = aws_sns_topic.events.arn }
        }
      }
    ]
  })
}