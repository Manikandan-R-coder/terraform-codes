# Terraform Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Provider Block
provider "aws" {
  region  = "ap-south-1" # Corrected region code
  profile = "default"
}

# Create Key Pair
resource "aws_key_pair" "my_key" {
  key_name   = "mum_license"
  public_key = <<-EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCD5077dPnQfbxobewsz6LLEwRAkIHeI9yMw9qei0Z88DI0sylw4shwROHpWF0OG3KSBvi8uFWkb5BL7Mda+nLSCmELtJY8A1qFPhqCMXPFfmM0ufKv082CV7DNOwWqZR/NfAah2p2+CmE5vo2103lbFWzGqIreFa+48kuADiQEZtGQ941/gBHYVcpENGJifT05Ddv9NCVapcySQfBTpRYzBZFhHk3VsmOvHaVT6p59pBlCUe8sADIufJhhmuC+P+4rgAk4GFLOGgvInKpSSRBHgrmJe6lyKr/qQSlo2nKljEjiMDM3n7y5yG1UYfKWLowVLe21DI8bDuQPZU3Sn3wL  EOF

EOF
}

# Security Groups and EC2 Instance resources remain the same...

# Create EC2 Instance
resource "aws_instance" "my-ec2-vm" {
  ami                    = "ami-007020fd9c84e18c7"
  instance_type          = "t2.micro"
  count                  = 1 # Corrected to integer
  key_name               = aws_key_pair.my_key.key_name
  tags = {
    "Name" = "myec2vm"
  }
}
