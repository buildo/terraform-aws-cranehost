resource "aws_security_group" "sg" {
  name = var.project_name
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  protocol          = "tcp"
  security_group_id = aws_security_group.sg.id
  from_port         = 22
  to_port           = 22
  cidr_blocks       = var.in_cidr_blocks
}

resource "aws_security_group_rule" "out_all" {
  type              = "egress"
  protocol          = -1
  security_group_id = aws_security_group.sg.id
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "custom_ports" {
  count             = length(var.in_open_ports)
  type              = "ingress"
  protocol          = "tcp"
  security_group_id = aws_security_group.sg.id
  from_port         = 2 == length(split("-", element(var.in_open_ports, count.index))) ? element(split("-", element(var.in_open_ports, count.index)), 0) : element(var.in_open_ports, count.index)

  to_port = 2 == length(split("-", element(var.in_open_ports, count.index))) ? element(split("-", element(var.in_open_ports, count.index)), 1) : element(var.in_open_ports, count.index)

  cidr_blocks = var.in_cidr_blocks
}

