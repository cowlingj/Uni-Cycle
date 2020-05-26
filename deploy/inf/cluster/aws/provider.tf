provider "aws" {
  region                  = "us-west-2"
  shared_credentials_file = "${path.root}/secrets/aws/creds"
  # profile                 = ""
}
