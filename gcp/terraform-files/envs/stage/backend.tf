terraform {
  backend "gcs" {
    bucket = "project-state-bucket-test"
    prefix = "terraform/state/test"
  }
}
