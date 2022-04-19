terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

variable "ami" {
 #default  = "ami-04505e74c0741db8d" #east1
 default = "ami-0fb653ca2d3203ac1" #east2
}

variable "aws_region" {
 default = "us-east-2"
}

variable "availability_zone" {
  type = string
  default = "us-east-2b"
}

variable "keys" {
  default = "terraform-keys-east2"
}

variable "instance_type" {
  default = "t2.nano"
}

variable "aws_access_key_id" {
  description = "The aws access key id for terraform user."
  type        = string
}

variable "aws_secret_access_key" {
 description = "The aws secret access key for terraform user."
 type        = string
}



# Configure the AWS Provider
provider "aws" {
    region = "us-east-2"
}

resource "aws_vpc" "slurmqueen-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "slurmqueen-vpc"
  }
}

resource "aws_internet_gateway" "slurmqueen-gw" {
  vpc_id = aws_vpc.slurmqueen-vpc.id

  tags = {
    Name = "slurmqueen-gw-single"
  }
}

resource "aws_route_table" "slurmqueen-route-table" {
  vpc_id = aws_vpc.slurmqueen-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.slurmqueen-gw.id
  }

  tags = {
    Name = "slurmqueen-route-table-single"
  }
}

# Subnet where the webserver resides on
resource "aws_subnet" "slurmqueen-subnet" {
  vpc_id     = aws_vpc.slurmqueen-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name = "slurmqueen-subnet"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.slurmqueen-subnet.id
  route_table_id = aws_route_table.slurmqueen-route-table.id
}

# Security group
resource "aws_security_group" "allow_web_traffic" {
  name        = "allow_web_traffic"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.slurmqueen-vpc.id

  ingress {
    description      = "HTTPS traffic from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP traffic from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH traffic from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web_traffic"
  }
}

# Provides an Elastic network interface (ENI) resource.

resource "aws_network_interface" "web-server-nic1" {
  subnet_id       = aws_subnet.slurmqueen-subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web_traffic.id]
}


#Public IP - Provides an Elastic IP resource.
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic1.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.slurmqueen-gw]
}


#resource "aws_ebs_volume" "first-terraform-ec2-volume" {
#  availability_zone = var.availability_zone
#  size              = 1024
#
#  tags = {
#    Name = "VolumeAttachedToEc2ForQueensState"
#  }
#}

#resource "aws_volume_attachment" "first-terraform-ec2-volume-attachment" {
#  device_name = "/dev/sdh"
#  volume_id = "${aws_ebs_volume.first-terraform-ec2-volume.id}"
#  instance_id = "${aws_instance.first-terraform-ec2.id}"
#}

resource "aws_instance" "first-terraform-ec2" {
  ami               = var.ami
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  key_name          = var.keys

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-server-nic1.id
  }
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 16
  }
  tags = {
    Name = "Ec2ForSlurmQueen"
  }
}


#resource "null_resource" "first-terraform-ec2" {
#  // copy our example script to the server
#  provisioner "file" {
#    source      = "actual.sh"
#    destination = "/tmp/provision.sh"
#  }
#
#  // change permissions to executable and pipe its output into a new file
#  provisioner "remote-exec" {
#    inline = [
#      "chmod +x /tmp/provision.sh",
#      "/tmp/provision.sh",
#    ]
#  }
#
#  connection {
#      type = "ssh"
#      host = aws_instance.first-terraform-ec2.public_ip
#      user = "ubuntu"
#   }
#}

terraform {
  backend "s3" {
    bucket = "slurmqueen-terraform-states"
    key    = "mvp/slurmd-instance-april18"
    # TODO: figure out why error "Variables may not be used here."
    region = "us-east-2"
  }
}

output "Done" {
    value = "Finally Done!"
}