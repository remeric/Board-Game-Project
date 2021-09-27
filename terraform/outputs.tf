
output "eks_cluster_endpoint" {
  value = aws_eks_cluster.BGcluster.endpoint
}

output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.BGcluster.certificate_authority 
}