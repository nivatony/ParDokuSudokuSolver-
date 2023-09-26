provider "aws" {
  region = "eu-north-1"  # Replace with your desired region.
}

resource "aws_ecr_repository" "sudoku_solver_app1" {
  name = "sudoku_solver_app1"
  
  # Additional ECR configuration...
  image_scanning_configuration {
    scan_on_push = true  # Enable image scanning on push

    # Specify additional scan findings that trigger a notification
    scan_on_push_notification {
      severity_levels = ["MEDIUM", "HIGH", "CRITICAL"]
      notification_arns = ["arn:aws:sns:eu-north-1:712699700534:Ecr_scan"]
    }
  }

  # Set repository policy to control access
  policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        Sid = "AllowPushPull",
        Effect = "Allow",
        Principal = "*",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:GetRepositoryPolicy",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:GetLifecyclePolicy",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:GetImageScan",
          "ecr:GetImageManifest",
          "ecr:PutImage",
          "ecr:PutImageScanningConfiguration",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
        ],
        Resource = "*"
      }
    ]
  })
}


output "ecr_repository_url" {
  value = aws_ecr_repository.sudoku_solver.repository_url
}

