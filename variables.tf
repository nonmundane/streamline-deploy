variable "domainname" {
  type    = string
  default = "pookflix.com"
}
variable "bucket" {
  type    = string
  default = "pookflix"
}
variable "instance_type" {
  # this app is network sensitive primarily, a t3.small should run it fine
  default = "t3.small"
}
variable "hostname" {
  type    = string
  default = "stream"
}
variable "instance_name" {
  type = string
  default = "streamlineinstance"
}
variable "aws_region" {
  default = "us-west-2"
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
