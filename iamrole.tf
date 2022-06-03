resource "aws_iam_role" "S3DynamoDBFullAccessRole" {
  name = "S3DynamoDBFullAccessRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy" "aws_s3_fullaccess" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
data "aws_iam_policy" "aws_dynamodb_fullaccess" {
  arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "S3DynamoDBFullAccessRole_policies_attachment" {
  for_each = {
    "key1" = data.aws_iam_policy.aws_dynamodb_fullaccess
    "key2" = data.aws_iam_policy.aws_s3_fullaccess
  }
  role = "${aws_iam_role.S3DynamoDBFullAccessRole}"
  policy_arn = each.value
}