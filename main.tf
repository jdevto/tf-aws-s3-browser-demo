terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.94.1"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

resource "random_string" "suffix" {
  length  = 3
  special = false
  upper   = false
}

module "s3_browser" {
  source = "tfstack/s3-browser/aws"

  s3_config = {
    bucket_name          = "s3-browser"
    bucket_suffix        = random_string.suffix.result
    enable_force_destroy = true
    source_file_path     = "${path.module}/external"
  }

  tags = {
    Name = "s3-browser-${random_string.suffix.result}"
  }
}

output "s3_website_url" {
  value = module.s3_browser.s3_website_url
}
