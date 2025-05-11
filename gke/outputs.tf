variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "Google Cloud Region"
  type        = string
}

variable "zone" {
  description = "Google Cloud Zone"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "initial_node_count" {
  description = "Initial number of nodes in the cluster"
  type        = number
}

variable "min_node_count" {
  description = "Minimum number of nodes in the cluster"
  type        = number
}

variable "max_node_count" {
  description = "Maximum number of nodes in the cluster"
  type        = number
}

variable "machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
}

variable "network" {
  description = "The VPC network to host the cluster in"
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in"
  type        = string
}

variable "pod_cidr" {
  description = "CIDR range for pods"
  type        = string
}

variable "service_cidr" {
  description = "CIDR range for services"
  type        = string
}