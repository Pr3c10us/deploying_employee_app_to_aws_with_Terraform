resource "aws_dynamodb_table" "employee-db" {
  name = "Employees"
  read_capacity  = 20
  write_capacity = 20
  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
