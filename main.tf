provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# # Get latest Windows Server 2012R2 AMI
# data "aws_ami" "windows_2012_r2" {
#   most_recent = true
#   owners      = ["amazon"]
#   filter {
#     name   = "name"
#     values = ["Windows_Server-2012-R2_RTM-English-64Bit-Base-*"]
#   }
# }

# # Get latest Windows Server 2016 AMI
# data "aws_ami" "windows_2016" {
#   most_recent = true
#   owners      = ["amazon"]
#   filter {
#     name   = "name"
#     values = ["Windows_Server-2016-English-Full-Base*"]
#   }
# }

# Get latest Windows Server 2019 AMI
data "aws_ami" "windows_2019" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }
}

# # Get latest Windows Server 2022 AMI
# data "aws_ami" "windows_2022" {
#   most_recent = true
#   owners      = ["amazon"]
#   filter {
#     name   = "name"
#     values = ["Windows_Server-2022-English-Full-Base*"]
#   }
# }

# Generates a secure private key and encodes it as PEM
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create the Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = "windows-key-pair"
  public_key = tls_private_key.key_pair.public_key_openssh
}

# Save file
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.key_pair.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
}

resource "aws_instance" "process_explorer_server" {
  ami           = data.aws_ami.windows_2019.id
  instance_type = "t2.small"

  key_name        = aws_key_pair.key_pair.key_name
  security_groups = ["${aws_security_group.process_explorer_server_sg.name}"]

  tags = {
    Name        = "process-explorer-windows-server"
    Environment = "dev"
  }
}

resource "aws_security_group" "process_explorer_server_sg" {
  name        = "process_explorer_server"
  description = "Allow rdp and HTTP(s) traffic"


  ingress {
    from_port = 3389 #  By default, the windows server listens on TCP port 3389 for RDP
    to_port   = 3389
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming RDP connections"
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP connections"
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTPS connections"
  }


  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outgoing connections"
  }
}