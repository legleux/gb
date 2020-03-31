provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone
  remove_default_node_pool = true
  initial_node_count       = var.node_count
  master_auth {
    username = ""
    password = ""
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = var.machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
  provisioner "local-exec" { # hmm, seems hacky but it worked!
    command = "gcloud container clusters get-credentials ${var.cluster_name}"
  }
}

provider "helm" {
  kubernetes {}
}

resource "helm_release" "local" {
  depends_on = [google_container_node_pool.primary_preemptible_nodes]
  name       = "guestbook"
  chart      = "./guestbook_helm/guestbook-h/"
  values = [
    "${file("./guestbook_helm/guestbook-h/values.yaml")}"
  ]
}

resource "helm_release" "postgres" {
  depends_on = [google_container_node_pool.primary_preemptible_nodes]
  name  = "postgres"
  chart = "bitnami/postgresql"

  values = [
    "${file("./guestbook_helm/postgres/pg-helm-values.yaml")}"
  ]
}
