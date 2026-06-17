terraform {
  backend "gcs" {
    bucket = "project-state-bucket-prod"
    prefix = "terraform/state/prod"
  }
}
