locals {

  name_prefix_environment = var.environment == "DEV" ? "d" : "p"
  name_prefix_region      = var.region == "eu-central-1" ? "ec1" : ""
  name_prefix             = "${local.name_prefix_environment}-${local.name_prefix_region}-${var.owner}"

  common_tags = {
    Env = var.environment
    Owner = var.owner
    Region = var.region
  }
}