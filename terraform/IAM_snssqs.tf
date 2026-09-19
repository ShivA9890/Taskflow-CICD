resource "aws_iam_role_policy" "iam_role_snssqsdynamodb" {
  name = "taskflow_role_to_connect_SNS-SQS-DynamoDB"

  role = aws_iam_role.eks_worker.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sns:Publish"
        Resource = aws_sns_topic.events.arn
      },
      {
        Effect = "Allow"
        Action = [
          "sqs:RecieveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = [
          aws_sqs_queue.notify.arn,
          aws_sqs_queue.activity.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ]
        Resource = [
          aws_dynamodb_table.activity_tb.arn,
          "${aws_dynamodb_table.activity_tb.arn}/index/*"
        ]
      }
    ]
  })
}