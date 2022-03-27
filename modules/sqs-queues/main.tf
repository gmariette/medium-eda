resource "aws_sqs_queue" "submit" {
  name                      = "${var.project}-${var.env}-submit"
  delay_seconds             = 90
  max_message_size          = 262144
  message_retention_seconds = 3600
  receive_wait_time_seconds = 10
  visibility_timeout_seconds = 180

  tags = {
    Environment = "${var.env}"
    Project = "${var.project}"
  }
}

resource "aws_sqs_queue_policy" "submit_policy" {
  queue_url = aws_sqs_queue.submit.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:*",
      "Resource": "arn:aws:sqs:${var.region}:${var.aws_account}:function:*"
    }
  ]
}
POLICY
}