resource "aws_launch_template" "my_launch_template" {

   name = "my_launch_template"

   image_id = "ami-0989fb15ce71ba39e"
   instance_type = "t3.micro"
 
  
   user_data = filebase64("${path.module}/Sudokusolver.py")

   block_device_mappings {
     device_name = "/dev/sda1"

     ebs {
       volume_size = 20
       volume_type = "gp2"
    }
  }

    capacity_reservation_specification {
      capacity_reservation_preference = "open"
  }

    placement {
      availability_zone = "eu-north-1"
  } 

    ram_disk_id = "ari-12345678"

    metadata_options {
       http_endpoint               = "enabled"
       http_tokens                 = "required"
       http_put_response_hop_limit = 1
       instance_metadata_tags      = "enabled"
  }

     monitoring {
       enabled = true
  }


     cpu_options {
       core_count       = 4
       threads_per_core = 2
  }

    credit_specification {
      cpu_credits = "standard"
  }

    disable_api_stop        = true
    disable_api_termination = true

    ebs_optimized = true

    network_interfaces {
       associate_public_ip_address = true

    }

   elastic_inference_accelerator {
     type = "eia1.medium"
  }

   vpc_security_group_ids = ["sgr-010d520a816dabc31"]

   tag_specifications {
     resource_type = "instance"

     tags = {
       Name = "test"
    }
  }



}
