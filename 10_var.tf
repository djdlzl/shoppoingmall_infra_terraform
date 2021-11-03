variable "name" {
  type = string
  #default = "jwcho"
}

variable "avazone" {
  type = list
  #default = ["a","c"]
}

variable "region" {
  type = string
  #default = "ap-northeast-2"
}

variable "key" {
  type = string
  #default = "tf-key1"
}

variable "cidr_internet" {
  type = string
  #default = "0.0.0.0/0"
}

variable "cidr_main" {
  type = string
  #default = "10.0.0.0/16"
}

variable "public_s" {
  type = list
  #default = ["10.0.0.0/24","10.0.2.0/24"]
}

variable "private_s" {
  type = list
  # default = ["10.0.1.0/24","10.0.3.0/24"]  
}

variable "db_s" {
  type = list
  # default = ["10.0.4.0/24","10.0.5.0/24"]  
}

variable "private_ip" {
  type = string
}

variable "port_http" {
  type = string
}
variable "port_ssh" {
  type = string
}
variable "port_mysql" {
  type = string
}
variable "port_icmp" {
  type = string
}
variable "port_tomcat" {
  type = string
}

variable "web_instance_type" {
  type = string
}

variable "was_instance_type" {
  type = string
}

variable "db_instance_type" {
  type = string
}
