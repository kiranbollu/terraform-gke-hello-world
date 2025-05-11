resource "kubernetes_ingress_v1" "hello_world_ingress" {
  metadata {
    name      = "hello-world-ingress"
    namespace = var.namespace
    annotations = {
      "kubernetes.io/ingress.class"                 = "gce"
      "kubernetes.io/ingress.global-static-ip-name" = "hello-world-ip"
      "networking.gke.io/managed-certificates"      = "hello-world-cert"
      "kubernetes.io/ingress.allow-http"            = "true"
    }
  }

  spec {
    default_backend {
      service {
        name = kubernetes_service.hello_world.metadata[0].name
        port {
          number = 80
        }
      }
    }

    rule {
      http {
        path {
          path = "/*"
          backend {
            service {
              name = kubernetes_service.hello_world.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}