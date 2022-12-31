terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"
    }
  }
}
provider "kubernetes" {
  config_path    = "/c/Users/Miskeen/.kube/config"
}

provider "aws" {
  region = "us-west-2"
}