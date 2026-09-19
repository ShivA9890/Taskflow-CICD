resource "aws_sns_topic" "events" {
  name = "taskflow_events"

  tags = {
    Project     = "Taskflow"
    environment = "practice"
    Component   = "Event-bus"
  }

}