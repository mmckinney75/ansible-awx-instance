resource "aws_alb" "ansible-awx-alb" {
  name                = "ansible-awx-alb"
  subnets             = ["${data.aws_subnet_ids.subnets_pub.ids}"]
  security_groups     = ["${aws_security_group.ansible_awx_alb_sg.id}"]
  internal            = "false"
  load_balancer_type  = "application"
}

resource "aws_alb_target_group" "ansible-awx-alb-tg" {
  name        = "ansible-awx-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = "${var.vpc_id}"
  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    path                = "/"
    interval            = 30
    matcher             = 200
  }
}

resource "aws_alb_target_group_attachment" "ansible-awx-alb-tg-attachment" {
  target_group_arn = "${aws_alb_target_group.ansible-awx-alb-tg.arn}"
  target_id        = "${aws_instance.ansible-awx-ubuntu.id}"
  port             = 80
}

resource "aws_alb_listener" "ansible-awx-alb-listener" {
  load_balancer_arn = "${aws_alb.ansible-awx-alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.awx_cert_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.ansible-awx-alb-tg.arn}"
    type             = "forward"
  }
}
