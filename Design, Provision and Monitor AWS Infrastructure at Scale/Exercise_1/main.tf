# Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = "ASIAW42QMM5JSO2W2LGB"
  secret_key = "qSJ1SdcL94ExFKio20GbWXDmIlyjbP0ig0dZE1eA"
  token="FwoGZXIvYXdzEPv//////////wEaDM5caACPFzQGADVKoSLVAbD0AxX+Et6uAzakwTlnNNznoswKKNN48Bp5I2aGRn0vRs0VswWV/CXrkmeor+vGtHTrPbFXLSHTCeJL78uhoxI51WXfdM+vjQiOXU/K9Hfaqrjl6epeU3UPeeeRF/F3EoJFRgy//lF1r6MSkYdEsDHZozkqah+2pCy2J2fjobnlYhKjV6+VAwLCK6ynIoj04nEq7UWhEK8Wkoag183tsflheGZAKGjtPnzGVbCFnCl9waaWXCc0j2GFJYf3wyF78UXqIliYw7cG7NMgpiPPdBmjAdQ+KCiat7qnBjItyhH35rNovE5DIO3tuqhsg+1Am+FXNtaAX6ltGXKuzEybczEcCgBDH5t1vK9L"
  region = "us-east-1"
}

# Provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "udacity_t2" {
  count         = 4
  ami           = "ami-0742b4e673072066f"
  instance_type = "t2.micro"
  tags = {
    Name = "Udacity T2"
  }
}

# Provision 2 m4.large EC2 instances named Udacity M4
#resource "aws_instance" "udacity_m4" {
#  count         = 2
#  ami           = "ami-0742b4e673072066f"
#  instance_type = "m4.large"
#  tags = {
#    Name = "Udacity M4"
#  }
#}