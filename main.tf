provider "aws" {
    region = "us-east-1"
}

data "aws_ami" "amazon2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["Amazon*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


output image_id { 
   value = data.aws_ami.amazon2.id
}









variable "resource_tags" {
    type = map(string)
    default = {}
}

variable "project" {
}

locals {
  required_tags = {
      "project" = "impacta",
      "environment" = "prod"
  }
  tags = merge(var.resource_tags, local.required_tags)
}

output "tags" {
  value = local.tags
}

locals {
    name_suffix = format("%s_%s", var.project, local.required_tags["environment"])
}

output "resource_name" {
  value = local.name_suffix
}

#####

variable "env" {
    type = string
}

variable "size" {
    type = map
    default = {
       "qa" = "Large",
       "dev" = "small",
       "prod" = "xLarge"
    } 
}

output "ambiente"{
    value = lookup(var.size, var.env)
}

######


variable "curso" {
}

variable "pacotes" {
 default = ["docker","vim"]
}


data "template_file" "user_data" {
    template = file("user_data.sh")
    vars = {
          curso = var.curso
          pacotes = join(" ",var.pacotes)

    }
}

output "user_data" {
    value = data.template_file.user_data.rendered
}



