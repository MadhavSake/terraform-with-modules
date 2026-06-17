terraform {
  backend "gcs" {
    bucket = "state-bucket-test"
    prefix = "terraform/state/sample-test"
  }
}
