resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }

  vpc_security_group_ids = [aws_security_group.instance.id]

  subnet_id = aws_subnet.private.id

  key_name = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
}

resource "aws_security_group" "instance" {
  name_prefix = "example-instance-sg"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.1.0/24"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "example-vpc"
  }
}
