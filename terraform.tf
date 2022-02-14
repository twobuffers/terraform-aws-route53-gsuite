# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.13.0"
}

# ------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ------------------------------------------------------------------------------

terraform {
  required_providers {
    aws = {
      # https://registry.terraform.io/providers/hashicorp/aws/latest
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}
