resource "aws_iam_role" "eks_role" {
  name = "taskflow_eks_IAM_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_eks_cluster" "taskflow_eks" {
  name     = "taskflow_cluster"
  role_arn = aws_iam_role.eks_role.arn
  version  = "1.36"

  vpc_config {
    subnet_ids = module.vpc.public_subnets
  }
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_role_policy
  ]
}