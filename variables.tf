variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in (required)"
  default     = "conversational-agent-commonnet"
}

variable "region" {
  type        = string
  description = "The region to host the cluster in"
  default     = "us-east1"
}

variable "project_number" {
  type        = string
  description = "The project number"
  default     = "897255260469"
}
variable "enable_apis" {
  type        = set(string)
  description = "APIs to enable in the project"
  default = [
    "compute.googleapis.com",
    "servicenetworking.googleapis.com",
    "dns.googleapis.com",
    "storage.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
  ]
}

