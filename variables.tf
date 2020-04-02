variable project_name {
  description = "Project name, used for namespacing things"
}

variable instance_type {
  default = "t2.micro"
}

variable ami {
  description = "Custom AMI, if empty will use latest Ubuntu"
  default     = ""
}

variable volume_size {
  description = "Volume size"
  default     = 8
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
  default     = ""
}

variable in_open_ports {
  default = []
}

variable in_cidr_blocks {
  default = ["0.0.0.0/0"]
}

variable disk_utilization_alarm_threshold {
  description = "disk occupation alarm threshold (% of disk utilization)"
  default     = "80"
}

variable bellosguardo_target {
  description = "Possible values are 'buildo', 'omnilab'"
}

variable iam_instance_profile {
  default = ""
}
