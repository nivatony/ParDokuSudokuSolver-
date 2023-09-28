resource "aws_launch_template" "my_launch_template" {

  name = "my_launch_template"

  image_id = "ami-0989fb15ce71ba39e"
  instance_type = "t2.micro"
  key_name = "ubuntu"
  
  user_data = filebase64("${path.module}/Sudokusolver.py")

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.node_group_one.id]
  }
}

resource "aws_autoscaling_group" "my_asg" {
  name                      = "my_asg"
  max_size                  = 5
  min_size                  = 2
  health_check_type         = "ELB"    # optional
  desired_capacity          = 2
  target_group_arns = [aws_lb_target_group.my_tg.arn]

  vpc_zone_identifier       = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_1.id]
  
  launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = "$Latest"
  }
}

