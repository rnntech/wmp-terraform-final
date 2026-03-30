resource "aws_security_group" "main" {
  name = "${var.component}-${var.env}"

  dynamic "ingress" {
    for_each = var.ports
    content {
      from_port   = ingress.value    # 80, 443, 22
      to_port     = ingress.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      description = ingress.key      # HTTP, HTTPS, SSH
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "" {
    ami         = data.ami
    instance_type = var.
    vpc_security_group_ids = data.security_group
    tags = {
        Name = "${var.component}"
    }
}

