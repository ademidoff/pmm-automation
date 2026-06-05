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

  backend "gcs" {
    bucket = "pmm-data"
    prefix = "pmm-highload"
  }
}

provider "linode" {
  token = var.linode_token
}
