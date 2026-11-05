variable "region"        { default = "ap-south-1" }
variable "instance_type" { default = "t3.micro" }
variable "key_name"      { description = "Existing EC2 key pair name" }
variable "my_ip"         { description = "Your public IP, e.g. 1.2.3.4/32" }
