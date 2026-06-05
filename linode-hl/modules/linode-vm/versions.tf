terraform {
  required_version = ">= 1.14"

  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 3.13"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.9"
    }
  }
}
