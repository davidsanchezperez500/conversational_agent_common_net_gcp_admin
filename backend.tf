terraform {
  backend "gcs" {
    bucket = "conversational-agent-terraform-state-common-net"
  }
}
