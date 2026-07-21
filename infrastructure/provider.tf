terraform {
    required_providers {
        aws = {
            version =">=4.9.0"
            source = "hashicorp/aws"
        }
    }
}
provider "aws" {
    region = "ap-southeast-2"
    # Credentials are NOT set here. Terraform will pick them up automatically from,
    # in order of precedence: environment variables (AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY),
    # your shared credentials file (~/.aws/credentials), or an assumed IAM role.
    # Never hardcode access_key/secret_key in this file.
}