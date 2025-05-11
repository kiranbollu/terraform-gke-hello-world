output "vpc_name" {
  value = module.vpc.vpc_name
}

output "subnet_name" {
  value = module.vpc.subnet_name
}

output "cluster_name" {
  value = module.gke.cluster_name
}

output "cluster_endpoint" {
  value = module.gke.endpoint
}

output "ingress_ip" {
  value = module.kubernetes_resources.ingress_ip
}

output "github_repository_url" {
  value = "https://github.com/${github_repository.hello_world.full_name}"
}