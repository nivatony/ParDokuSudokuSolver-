resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name"        = "${var.cluster_name}-${var.environment}-internet-gateway"
    "ClusterName" = var.cluster_name
    "Environment" = var.environment
  }
}
