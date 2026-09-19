resource "aws_iam_role" "eks_worker" {
  name = "taskflow_worker"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "worker_reg" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_worker.name
}

resource "aws_iam_role_policy_attachment" "worker_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_worker.name
}

resource "aws_iam_role_policy_attachment" "worker_ecr" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.eks_worker.name
  
}

resource "aws_iam_role_policy_attachment" "worker_secret" {
   policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
    role = aws_iam_role.eks_worker.name
}

resource "aws_eks_node_group" "eks_workers" {
  cluster_name    = aws_eks_cluster.taskflow_eks.name
  node_group_name = "taskflow_workers"
  node_role_arn   = aws_iam_role.eks_worker.arn

  subnet_ids = module.vpc.public_subnets

  instance_types = ["m7i-flex.large"]
  ami_type = "AL2023_x86_64_STANDARD"

  remote_access {
    ec2_ssh_key = aws_key_pair.aws_key.key_name
  }

  scaling_config {
    desired_size = 3
    max_size     = 4
    min_size     = 2
  }

  depends_on = [aws_iam_role_policy_attachment.worker_reg, aws_iam_role_policy_attachment.worker_cni]

  tags = {
    Project     = "taskflow"
    environment = "practice"
  }


}