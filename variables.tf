variable "instance_ami" {
  description = "The AMI to use to launch the Streamline instance"
  type        = string
  default     = ""
}

variable "instance_public_dns" {
  type    = string
  default = ""
}

variable "aws_region" {
  default = ""
}

variable "instance_type" {
  # this app is network sensitive primarily, a t3.small should run it fine
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "instance_spot" {
  description = "Use a spot instance instead of an on-demand one"
  type        = bool
  default     = true
}

variable "instance_spot_price" {
  description = "The maximum spot price to accept when creating a spot instance"
  type        = string
  default     = ""
}

variable "instance_spot_block_duration" {
  description = "The block duration to request for the spot instance"
  type        = number
  default     = 0
}

variable "private_key_file" {
  description = "Whether to output a private key file for use by ssh"
  type        = bool
  default     = true
}
