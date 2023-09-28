resource "aws_lb" "my_alb" {
  name               = "${var.cluster_name}_alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  enable_deletion_protection = false

  enable_http2 = true
  enable_cross_zone_load_balancing = true

  tags = {
    "Name"        = "${var.cluster_name}_alb"
    "ClusterName" = var.cluster_name
    "Environment" = var.environment
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      #content      = "OK"
    }
  }
}
