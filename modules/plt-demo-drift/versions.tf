# Without this block the `scaleway_*` resources below resolve to the implicit
# legacy provider address `hashicorp/scaleway` instead of the root's
# `scaleway/scaleway`. Those are two distinct providers: the module's copy never
# inherits the root `provider "scaleway"` config, so it runs with no credentials
# and every resource fails at apply with "invalid API key format or empty value"
# — after a clean plan, because a create-only plan calls no API.
terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.0"
    }
  }
}
