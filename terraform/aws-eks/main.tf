#Installing on AWS EKS - testing/practice only
#Recommed installing on AWS ECS as it is cheaper than EKS

#run the below command after running terraform apply to connect to the cluster, then run terraform apply again
#aws eks update-kubeconfig --name BGcluster --region us-east-1

terraform {
  backend "s3" {
    bucket         = "terraform-backend-state-remeric"
    key            = "bgapp/aws-eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "application_locks"
    encrypt        = "true"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#x509 certificate error need to troubleshoot to make secure
provider "kubernetes" {
  host                   = data.aws_eks_cluster.BGcluster.endpoint
  token                  = data.aws_eks_cluster_auth.BGcluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.BGcluster.certificate_authority.0.data)
  config_path            = "~/.kube/config"
}

resource "aws_iam_role" "eksClusterRole_bg" {
  name = "eksClusterRole_bg"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "eksNodeRole_bg" {
  name = "eksNodeRole_bg"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "AmazonEKSClusterPolicy" {
  name       = "AmazonEKSClusterPolicy"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  roles      = [aws_iam_role.eksClusterRole_bg.name]
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eksClusterRole_bg.name
}

resource "aws_eks_cluster" "BGcluster" {
  name       = "BGcluster"
  role_arn   = aws_iam_role.eksClusterRole_bg.arn
  depends_on = [aws_iam_role.eksClusterRole_bg]

  vpc_config {
    subnet_ids = ["subnet-032a69716a3249a39", "subnet-0c02bb6ec49a79209"]
  }

}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eksNodeRole_bg.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eksNodeRole_bg.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eksNodeRole_bg.name
}

resource "aws_eks_node_group" "BGnodes" {
  cluster_name    = aws_eks_cluster.BGcluster.name
  node_group_name = "bg_app"
  node_role_arn   = aws_iam_role.eksNodeRole_bg.arn
  subnet_ids      = ["subnet-032a69716a3249a39", "subnet-0c02bb6ec49a79209"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "kubectl_manifest" "Man_Deploy" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: board-game-selector
    version: v1
  name: board-game-selector-v1
  namespace: default
spec:
  replicas: 2
  minReadySeconds: 30
  selector:
    matchLabels:
      app: board-game-selector
  strategy:
   rollingUpdate:
     maxSurge: 50%
     maxUnavailable: 50%
   type: RollingUpdate
  template:
    metadata:
      labels:
        app: board-game-selector
        version: v1
    spec:
      containers:
      - image: remeric/board-game-selector:1.3
        imagePullPolicy: Always
        name: board-game-selector
      restartPolicy: Always 
      terminationGracePeriodSeconds: 45
YAML
}

resource "kubectl_manifest" "LB_Deploy" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  labels:
    app: board-game-selector
  name: board-game-selector
  namespace: default
spec:
  ports:
  - nodePort: 30369
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: board-game-selector
    version: v1
  sessionAffinity: None
  type: LoadBalancer
YAML
}