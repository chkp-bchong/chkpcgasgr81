variable "project_name" {
  description = "Project Name that will be used as prefix for all the resources deployed"
  default     = "chkp-bchong"
}

provider "aws" {
    profile = "default"
    region  = var.region
}

variable "region" {
  default = "ap-southeast-1"
}

data "aws_availability_zones" "azs" {
}

variable "key_name" {
  description = "Must be the name of an existing EC2 KeyPair"
  default     = "aws_bchong_keypair"
}

variable "northbound_cidr_vpc" {
  description = "Check Point Northbound VPC"
  default     = "10.168.0.0/16"
}

variable "password_hash" {
  description = "Hashed password for the Check Point servers - this parameter is optional"
  default     = "$1$qHItLuhY$xO6pPUXKNj5Om6Us7fUR7/"
}

variable "sic_key" {
  description = "One time password used to established connection between the Management and the Security Gateway"
  default     = "vpn123456"
}

variable "cpversion" {
  description = "Check Point version"
  default     = "R81"
}

variable "mgmt_size" {
  default = "m5.xlarge"
}

variable "northbound_asg_size" {
  default = "c5n.large"
}

variable "inbound_port" {
  default = "80"
}

variable "inbound_high_port" {
  default = "9080"
}

variable "inbound_protocol" {
  default = "HTTP"
}

variable "proxy_port" {
  description = "Port used for outgoing proxy traffic"
  default = "8080"
}

variable "managementserver_name" {
  default = "cpsms"
}

variable "configurationtemplate_name" {
  default = "cptemplate"
}