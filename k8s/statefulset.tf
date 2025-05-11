resource "kubernetes_storage_class" "standard" {
  metadata {
    name = "standard-rwo"
  }

  storage_provisioner = "kubernetes.io/gce-pd"
  parameters = {
    type = "pd-standard"
  }
  reclaim_policy      = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"
}

resource "kubernetes_stateful_set" "db" {
  metadata {
    name      = "mongodb"
    namespace = var.namespace
    labels = {
      app = "mongodb"
    }
  }
}
  spec {
    service_name = "mongodb-service"
    replicas     = 1
    pod_management_policy = "OrderedReady"

    selector {
      match_labels = {
        app = "mongodb"
      }
    }
  }
    template {
      metadata {
        labels = {
          app = "mongodb"
        }
      }
    }
      spec {
        container {
          name  = "mongodb"
          image = "mongo:4.4"

          port {
            container_port = 27017
            name           = "mongodb"
          }
        }
          volume_mount {
            name       = "data"
            mount_path = "/data/db"
          }
      }
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

          liveness_probe {
            exec {
              command = ["mongo", "--eval", "db.adminCommand('ping')"]
            }
            initial_delay_seconds = 30
            timeout_seconds       = 5
            period_seconds        = 10
            failure_threshold     = 3
          }
