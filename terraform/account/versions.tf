terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.26.0"
    }
    github = {
      source  = "integrations/github"
      version = "5.42.0"
    }

  }
  required_version = "1.6.4"
}
