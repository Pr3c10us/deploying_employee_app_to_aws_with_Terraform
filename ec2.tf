# resource "aws_iam_instance_profile" "employee-iam-profile" {
#   name = "employee-iam-profile"
#   role = "${aws_iam_role.S3DynamoDBFullAccessRole.name}"
# }
resource "aws_instance" "employee-app" {
  ami = "ami-0fa49cc9dc8d62c84"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.employee-sg.id]
  subnet_id = aws_subnet.employee-subnet["employee Public Subnet 1"].id
#   iam_instance_profile = aws_iam_instance_profile.employee-iam-profile.name
  key_name = "employee-kp"

  tags = {
    "Name" = "employee-app"
  }

  user_data = <<EOF
#!/bin/bash -ex
wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/DEV-AWS-MO-GCNv2/FlaskApp.zip
unzip FlaskApp.zip
cd FlaskApp/
yum -y install python3 mysql
pip3 install -r requirements.txt
amazon-linux-extras install epel
yum -y install stress
export PHOTOS_BUCKET=employee-photo-bucket-pr-101
export AWS_DEFAULT_REGION=us-east-2
export DYNAMO_MODE=on
FLASK_APP=application.py /usr/local/bin/flask run --host=0.0.0.0 --port=80
EOF

}
