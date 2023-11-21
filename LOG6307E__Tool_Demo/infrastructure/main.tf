terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.19.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  token      = var.aws_session_token
}

resource "aws_security_group" "security_group" {
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_alb" "load_balancer" {
  name            = "load-balancer"
  security_groups = [aws_security_group.security_group.id]
  subnets         = data.aws_subnets.all.ids
}

resource "aws_key_pair" "key_pair_name_t2" {
  key_name   = var.key_pair_name_t2
  public_key = file("my_terraform_key.pub")
}

resource "aws_instance" "instances_t2" {
  ami                    = "ami-03a6eaae9938c858c"
  instance_type          = "t2.large"
  key_name               = var.key_pair_name_t2
  vpc_security_group_ids = [aws_security_group.security_group.id]
  availability_zone      = "us-east-1d"
  user_data              = file("./setup.sh")
  count                  = 1
  tags = {
    Name = "T2"
  }
}

resource "aws_alb_target_group" "T2" {
  name     = "T2-instances-LOG6370"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
}

resource "aws_alb_listener" "listener" {
  load_balancer_arn = aws_alb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.T2.arn
  }
}

resource "aws_alb_listener_rule" "T2_rule" {
  listener_arn = aws_alb_listener.listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.T2.arn
  }

  condition {
    path_pattern {
      values = ["/cluster1"]
    }
  }
}

resource "aws_alb_target_group_attachment" "T2_attachments" {
  count            = length(aws_instance.instances_t2)
  target_group_arn = aws_alb_target_group.T2.arn
  target_id        = aws_instance.instances_t2[count.index].id
  port             = 80
}
