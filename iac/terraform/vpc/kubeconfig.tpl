apiVersion: v1
clusters:
- cluster:
    server: ${eks_cluster_endpoint}
    certificate-authority-data: ${eks_cluster_ca_data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: github-actions-role
  name: github-actions-role
current-context: github-actions
kind: Config
preferences: {}
users:
- name: github-actions
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator  # Use aws-iam-authenticator for authentication
      args:
        - "token"
        - "-i"
        - "${cluster_name}"
        - "-r"
        - "arn:aws:iam::712699700534:role/github-actions-role"  # Specify the IAM role ARN here

