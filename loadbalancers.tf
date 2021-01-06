resource "aws_lb" "chkp_ext_alb" {
  name               = "chkp-ext-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.cg_nb_sub.*.id
  security_groups    = [aws_security_group.chkp_ext_alb_sg.id]
  tags = {
    name = "${var.project_name}_ext_alb"
  }
}

resource "aws_lb_target_group" "chkp_ext_alb_tg" {
  name     = "chkp-ext-alb-tg"
  port     = var.inbound_high_port
  protocol = var.inbound_protocol
  vpc_id   = aws_vpc.cg_vpc.id
  tags = {
    name = "${var.project_name}_ext_alb_tg"
  }

  # Alter the destination of the health check to be the login page.
  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_listener" "chkp_ext_alb_listener" {
  load_balancer_arn = aws_lb.chkp_ext_alb.arn
  port              = 80
  protocol          = var.inbound_protocol

  default_action {
    target_group_arn = aws_lb_target_group.chkp_ext_alb_tg.arn
    type             = "forward"
  }
}


resource "aws_lb" "chkp_int_alb" {
  name               = "chkp-int-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = aws_subnet.cg_web_sub.*.id
  security_groups    = [aws_security_group.chkp_int_alb_sg.id]
  tags = {
    x-chkp-forwarding = "${var.inbound_protocol}-${var.inbound_high_port}-${var.inbound_port}"
    x-chkp-management = var.managementserver_name
    x-chkp-template   = var.configurationtemplate_name
  }
}

resource "aws_lb_listener" "chkp_int_alb_listener" {
  load_balancer_arn = aws_lb.chkp_int_alb.arn
  port              = var.inbound_port
  protocol          = var.inbound_protocol

  default_action {
    target_group_arn = aws_lb_target_group.chkp_int_alb_tg.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "chkp_int_alb_tg" {
  name     = "chkp-int-lb-tg"
  port     = var.inbound_port
  protocol = var.inbound_protocol
  vpc_id   = aws_vpc.cg_vpc.id
  tags = {
    name = "${var.project_name}_int_alb_tg"
  }
}

resource "aws_lb_target_group_attachment" "chkp_int_alb_tg_attachment" {
  count            = length(aws_instance.aws_webserver_instance)
  target_group_arn = aws_lb_target_group.chkp_int_alb_tg.arn
  target_id        = element(aws_instance.aws_webserver_instance.*.id, count.index)
  port             = var.inbound_port
}

