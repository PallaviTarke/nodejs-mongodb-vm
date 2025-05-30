provider "google" {
     project = var.project_id
     region  = var.region
     credentials = file(var.credentials_file)
   }

   resource "google_compute_instance" "vm_instance" {
     name         = "nodejs-mongodb-vm"
     machine_type = "e2-standard-2"
     zone         = "${var.region}-a"
     
     allow_stopping_for_update = true 
   
     boot_disk {
       initialize_params {
         image = "debian-cloud/debian-11"
         size  = 30
       }
     }
   
     network_interface {
       network = "default"
       access_config {
         // Ephemeral public IP
       }
     }
   
     metadata_startup_script = <<-EOF
       #!/bin/bash
       apt-get update
       apt-get install -y docker.io
       systemctl start docker
       systemctl enable docker
       curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
       chmod +x /usr/local/bin/docker-compose
       EOF
     
     service_account {
       email  = "428456782983-compute@developer.gserviceaccount.com"
       scopes = ["cloud-platform"]
     }
   }

   resource "google_artifact_registry_repository" "repo" {
     location      = var.region
     repository_id = "nodejs-mongodb-repo"
     format        = "DOCKER"
   }

  # resource "google_service_account" "vm_service_account" {
   #  account_id   = "vm-service-account"
    # display_name = "VM Service Account"
   #}

   #resource "google_service_account" "github_actions" {
    # account_id   = "github-actions-sa"
   #  display_name = "GitHub Actions Service Account"
  # }

   #resource "google_project_iam_member" "vm_service_account" {
    # project = var.project_id
    # role    = "roles/compute.admin"
    # member  = "serviceAccount:${google_service_account.vm_service_account.email}"
   #}

   #resource "google_project_iam_member" "github_actions" {
    # project = var.project_id
     #role    = "roles/compute.admin"
     #member  = "serviceAccount:${google_service_account.github_actions.email}"
   #}

   #resource "google_project_iam_member" "artifact_registry" {
    # project = var.project_id
     #role    = "roles/artifactregistry.writer"
     #member  = "serviceAccount:${google_service_account.github_actions.email}"
   #}

   output "vm_public_ip" {
     value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
   }

  # output "service_account_key" {
    # value     = google_service_account.github_actions.email
   #  sensitive = true
  # }
