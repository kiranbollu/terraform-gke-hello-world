# Create VPC and subnets
module "vpc" {
  source = "./vpc"

  project_id  = var.project_id
  region      = var.region
  vpc_name    = var.vpc_name
  subnet_name = var.subnet_name
  subnet_cidr = var.subnet_cidr
}

# Create GKE cluster in the VPC
module "gke" {
  source = "./gke"

  project_id         = var.project_id
  region             = var.region
  zone               = var.zone
  cluster_name       = var.cluster_name
  initial_node_count = var.initial_node_count
  min_node_count     = var.min_node_count
  max_node_count     = var.max_node_count
  machine_type       = var.machine_type
  network            = module.vpc.vpc_name
  subnetwork         = module.vpc.subnet_name
  pod_cidr           = var.pod_cidr
  service_cidr       = var.service_cidr
}

# Apply Kubernetes resources after the cluster is created
resource "kubernetes_namespace" "hello_world" {
  depends_on = [module.gke]

  metadata {
    name = "hello-world"
  }
}

module "kubernetes_resources" {
  source = "./k8s"

  namespace     = kubernetes_namespace.hello_world.metadata[0].name
  depends_on    = [kubernetes_namespace.hello_world]
}

# GitHub repository
resource "github_repository" "hello_world" {
  name        = "terraform-gke-hello-world"
  description = "Hello World application deployed on GKE using Terraform"
  visibility  = "public"
  auto_init   = true

  topics = ["terraform", "gke", "kubernetes", "hello-world"]
}