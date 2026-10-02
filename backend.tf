terraform {
  # key is per-account and supplied at init time (-backend-config="key=...")
  # by the GitHub Actions workflow, so different aws_account inputs never
  # share the same state file.
  backend "s3" {
    bucket  = "tf-klinsync"
    region  = "us-east-2"
    encrypt = true
  }
}