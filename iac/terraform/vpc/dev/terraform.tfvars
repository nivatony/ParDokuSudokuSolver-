cluster_name = "awesome_cluster"

# Service Account Variables
worker_nodes_sa_name = "my-worker-nodes"
worker_nodes_sa_namespace = "kube-system"

# Cluster Role Variables
read_only_pods_role_name = "my-read-only-pods"

# Cluster Role Binding Variables
worker_nodes_read_pods_binding_name = "my-worker-nodes-read-pods"



kubeconfig_content  = "apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJVW1jVXVhTm5WTmN3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TXpBNU1qWXhPVEF3TURkYUZ3MHpNekE1TWpNeE9UQXdNRGRhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURTUnhFYnRLbTM3RU9Lczkvd0xyMzFZVjJuVWwveTQyZDFKKzBaNjE1aCtZRGZkb0dQV0xGcTBZbmgKU1hQR0FKMjFaOFU0dk5vSWNabHlZaWk3Nko3VWR0VTBJSTdFMmNweEpzekVuOHhSeDZiS3NrVE9jN1F6ZTdTOQpTUnhOcFVmYllYSlQrTzZiTzJtWStsejI2cDRCNEtwcjVnZlhmU2F1YkpKSXd6NlNzZ2ZYK1REL2ZENm1YY0NLCjBNaFFmNGtYWXlPYUdwMDVKQWpXOCtLNFB6R1U0WXo5RjhsbDNUVTRrUWVISm5qNEV2OVV4QmoyVmVjNHA1dUMKK1hXK3hoREVSMVdrTit6bXEwUTFRa2NZY21MK3FidUdXcklRbVpaWGk5WFJyUnhWZHNyVGJMb1EvRmMvNmlPZwoxaVNtREVPOTQyUTZkbHZ1RS9ueXRtcnB2Y2duQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJSSTBMQWQ3OVhtMkp2TlhldkhPNEVJN3JlK0N6QVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQTlTQUoyVGU1NgpKeXZXSm5KWFlxUUFlN1hpQzlqVXRTV0E3ckRkVkpVdGhqekZxOEdEUGYzc0tFVUY3RjVBKzZKQlNtM1pwd04wCkZJRnkvQWN4RjNPSnVxaGs1VHNZQzA3bVJ1Z2J3SjRibDVVcEl3TmlaYXVBQXZDalRQSTlBdHFSalhpTnE5c28KenV3VmpmSWkyd3FIU0lqd2d4Q1NheEg1Q3cyTlBMQTF2N1RYdWt0RU9kT2dMS3kwbm5VbWUrK25rTmttM1FMcwpsQzdzbmI0MWY0dlN4YTFhR05LV3R0S3hBUUt1UHplcTFLbW82OHBQajRsQmJKd0c3aXdFcUk0RXJ1dEVQY011Ci9pTmE3b0RMOE5nU241NEpSTmk4WnJhanNjdzQzbjRmQzNjcDVHbHgrZmYrZXM3K0ZGemtzSG1IRDlvWmpkNkQKUC83b3BtZFJlcm5qCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
    server: https://A1F74ED07AA088951871AB27560E397C.gr7.eu-north-1.eks.amazonaws.com
  name: arn:aws:eks:eu-north-1:712699700534:cluster/awesome_cluster
contexts:
- context:
    cluster: arn:aws:eks:eu-north-1:712699700534:cluster/awesome_cluster
    user: arn:aws:eks:eu-north-1:712699700534:cluster/awesome_cluster
  name: arn:aws:eks:eu-north-1:712699700534:cluster/awesome_cluster
current-context: arn:aws:eks:eu-north-1:712699700534:cluster/awesome_cluster
kind: Config
preferences: {}
users:
- name: arn:aws:eks:eu-north-1:712699700534:cluster/awesome_cluster
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - --region
      - eu-north-1
      - eks
      - get-token
      - --cluster-name
      - awesome_cluster
      - --output
      - json
      command: aws"
kubeconfig_filename = "kubeconfig"


environment = "dev"

vpc_cidr_block = "10.0.0.0/16"

public_subnet_1_details = {
  availability_zone = "eu-north-1a"
  cidr_block        = "10.0.1.0/24"
}

public_subnet_2_details = {
  availability_zone = "eu-north-1b"
  cidr_block        = "10.0.2.0/24"
}

private_subnet_1_details = {
  availability_zone = "eu-north-1c"
  cidr_block        = "10.0.3.0/24"
}

private_subnet_2_details = {
  availability_zone = "eu-north-1c"
  cidr_block        = "10.0.4.0/24"
}

alb_name = "awesome_cluster_alb1"
key_pair = "MyKeyPair"
instance_types = "t2.micro"

scaling_min_size = 1
scaling_max_size = 3
scaling_desired_size = 2

node_group_name = "my-node-group"
eks_node_group_role_name = "node_group_role_niva"
eks_worker_node_policy_arn = "worker_node_policy_arn_niva"
eks_cni_policy_arn = "cni_policy_arn_niva"
ec2container_policy_arn = "c2container_policy_arn_niva"
eks_vpc_resource_controller_policy_arn = "vpc_resource_controller_policy_arn_niva"

