

variable "availability_zone" {
  description = "prod-ventura-availability_zone"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]

}

variable "public_subnet_cidr" {
  description = "public_subnet_cidr"
  type        = list(string)
  default     = ["10.0.1.0/28", "10.0.3.0/28"]

}

variable "private_subnet_cidr" {
  description = "private_subnet_cidr"
  type        = list(string)
  default     = ["10.0.4.0/23", "10.0.10.0/23", "10.0.14.0/23", "10.0.20.0/23", "10.0.25.0/27", "10.0.30.0/27"]
}

variable "ami" {
  description = "ami"
  type        = string
  default     = "ami-002070d43b0a4f171"

}

variable "instance_type" {
  description = "instance-type"
  type        = string
  default     = "t2.medium"
}

variable "tags" {
  description = "tags"
  type        = map(string)
  default = {
    "name" = "eip-instance"
  }
}
variable "subnet_id" {
  description = "value"
  type        = list(string)
  default     = ["aws_subnet.ventura-prod-subnet1.id", "aws_subnet.ventura-prod-subnet2.id"]

}

variable "aws_security_groupdesc" {
  description = "sg"
  type = string
  default = "aws_security_group_les"
}

# variable "ingress" {
#   description = "value"
#   type = object({
#     from_port = 80
#     to_port = 443
#     protocol =string
#     cidr_block = list(string)
#   })
#   default = {
# from_port = 22
# to_port = 22
# protocol = "tcp"
# cidr_block = [ "0.0.0.0/0" ]
#   }
# }