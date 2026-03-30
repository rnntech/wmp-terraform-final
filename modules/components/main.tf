resource "aws_security_group" "main" {
  name = "${var.component}-${var.env}"

  dynamic "ingress" {
    for_each = var.ports
    content {
      from_port   = ingress.value    # 80, 443, 22
      to_port     = ingress.value    #-1 means all protocols — TCP, UDP, ICMP, everything.
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

resource "aws_instance" "main" {
    ami         = data.aws_ami.ami.image_id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.main.id] #list - designed to accept multiple security groups — even if you only pass one, it still needs to be inside a list.
    tags = {
        Name = "${var.component}-${var.env}"
    }
}

resource "aws_route53_record" "dns" {
  zone_id = data.aws_route53_zone.main.zone_id    # hosted zone ID
  name    = "${var.component}-${var.env}"         # myserver.myapp.com
  type    = "A"                                   # A record = points to IP
  ttl     = 30                                    # seconds before DNS refreshes
  records = [aws_instance.main.private_ip]        # IP address
}

resource "null_resource" "ansible" {

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host     = aws_instance.main.private_ip
      user     = "ec2-user"
      password = "DevOps321"
    }
    inline = [
      "sudo labauto ansible",
      "ansible-pull -i localhost, -U https://github.com/raghudevopsb88/wmp-ansible-v4.git main.yml -e env=${var.env} -e COMPONENT=${var.component}"
    ]
  }
}
