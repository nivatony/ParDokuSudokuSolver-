# terraform/main.tf

variable "eks_assume_role_policy" {
  type        = string
  description = "IAM assume role policy for EKS cluster"
  default = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

variable "eks_admin_role_arn" {
  type        = string
  description = "ARN of the IAM role for EKS admin access"
  default     = "arn:aws:iam::712699700534:role/eks-admin"  # Replace with your IAM role ARN
}
