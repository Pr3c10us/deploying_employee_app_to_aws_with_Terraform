resource "aws_s3_bucket" "employee-s3" {
  bucket = "employee-photo-bucket-pre-101"
}

data "aws_iam_policy_document" "employee-iam-policy-doc" {
  statement {
    sid = "AllowS3ReadAccess"

    effect = "Allow"

    principals {
        type = "AWS"
        identifiers = ["arn:aws:iam::259023861827:role/S3DynamoDBFullAccessRole"]
    }

    actions = [
        "s3:*",
    ]    

    resources = [
        "arn:aws:s3:::employee-photo-bucket-pre-101",
        "arn:aws:s3:::employee-photo-bucket-pre-101/*"
    ]
  }
}
  
resource "aws_s3_bucket_policy" "employee-s3-policy" {
  bucket = aws_s3_bucket.employee-s3.id
  policy = data.aws_iam_policy_document.employee-iam-policy-doc.json
}