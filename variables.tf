variable project_name {
  description = "Project name, used for namespacing things"
}

variable instance_type {
  default = "t2.micro"
}

variable ami {
  description = "Custom AMI, if empty will use latest Ubuntu"
  default = ""
}

variable region {
  default = "eu-west-1"
}

variable subnet_id {
  description = "Subnet Id (default for buildo: subnet-789e130f, omnilab: subnet-13126d4a)"
}

variable volume_size {
  description = "Volume size"
  default = 8
}

variable ssh_private_key {
  description = "Used to connect to the instance once created"
}

variable ssh_key_name {
  description = "Name of the key-pair on EC2 (aws-ireland, buildo-aws, ...)"
}

variable zone_id {
  description = "Route53 Zone ID"
}

variable host_name {
  description = "DNS host name"
}

variable quay_password {
  description = "Quay password"
}

variable init_script {
  description = "bash code executed before `crane lift` is called, example: `\"${file(\"init.sh\")}\"`"
  default = ""
}

variable in_open_ports {
  default = []
}
