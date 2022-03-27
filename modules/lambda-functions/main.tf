resource "aws_lambda_function" "submit" {
  code_signing_config_arn = ""
  description             = "Submit"
  filename                = data.archive_file.lambda_submit.output_path
  function_name           = "${var.project}-submit"
  role                    = data.aws_iam_role.put_sqs.arn
  handler                 = "submit.lambda_handler"
  runtime                 = "python3.8"
  source_code_hash        = data.archive_file.lambda_submit.output_base64sha256
  timeout                 = 30

  environment {
    variables = {
      QUEUE_URL = data.aws_sqs_queue.submit.url
    }
  }
}

resource "aws_lambda_function" "create" {
  code_signing_config_arn = ""
  description             = "Create"
  filename                = data.archive_file.lambda_create.output_path
  function_name           = "${var.project}-create"
  role                    = data.aws_iam_role.put_sqs.arn
  handler                 = "create.lambda_handler"
  runtime                 = "python3.8"
  source_code_hash        = data.archive_file.lambda_create.output_base64sha256
  timeout                 = 30

}

resource "aws_lambda_event_source_mapping" "create_event_source_mapping" {
  event_source_arn = "${data.aws_sqs_queue.submit_post.arn}"
  enabled          = true
  function_name    = "${aws_lambda_function.create.arn}"
  batch_size       = 1
}