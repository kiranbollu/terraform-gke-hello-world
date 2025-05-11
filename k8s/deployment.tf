resource "kubernetes_deployment" "hello_world" {
  metadata {
    name      = "hello-world"
    namespace = var.namespace
    labels = {
      app = "hello-world"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "hello-world"
      }
    }

    template {
      metadata {
        labels = {
          app = "hello-world"
        }
      }

      spec {
        container {
          image = "gcr.io/google-samples/hello-app:1.0"
          name  = "hello-world"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "0.2"
              memory = "256Mi"
            }
          }

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "hello_world" {
  metadata {
    name      = "hello-world-service"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = kubernetes_deployment.hello_world.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "hello_world" {
  metadata {
    name      = "hello-world-hpa"
    namespace = var.namespace
  }

  spec {
    scale_target_ref {
      kind        = "Deployment"
      name        = kubernetes_deployment.hello_world.metadata[0].name
      api_version = "apps/v1"
    }
    min_replicas = 2
    max_replicas = 10

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 70
        }
      }
    }
  }
}
