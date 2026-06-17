terraform {
  backend "gcs" {
    bucket = "project-state-bucket"
    prefix = "terraform/state/qa"
  }
}
