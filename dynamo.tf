resource "aws_dynamodb_table" "employee-db" {
  name = "Employees"
  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }
}