variable "instance_label" {
  type    = string
  default = "pmm-server-hl"
}

variable "region" {
  type    = string
  default = "fr-par"
}

variable "instance_type" {
  type    = string
  default = "g6-standard-4"
}

variable "pmm_instance_type" {
  type        = string
  description = "Linode instance type for the PMM Server node"
  default     = "g6-standard-6"
}

variable "image" {
  type    = string
  default = "private/38885222"
}

variable "ssh_public_key" {
  type = string
}

variable "linode_token" {
  type = string
}

variable "firewall_id" {
  type        = number
  description = "ID of the existing Linode firewall to attach (default: pmm)"
  default     = 4112335
}

variable "pmm_docker_image" {
  type        = string
  description = "PMM server Docker image to run"
  default     = "perconalab/pmm-server:3-dev-latest"
}

variable "pmm_admin_password" {
  type        = string
  description = "PMM admin password. Auto-generated if null."
  default     = null
  sensitive   = true
}

variable "mysql_password" {
  type        = string
  description = "Password for MySQL root and sbtest users. Auto-generated if null."
  default     = null
  sensitive   = true
}

variable "postgres_password" {
  type        = string
  description = "Password for the postgres superuser. Auto-generated if null."
  default     = null
  sensitive   = true
}

variable "mongo_password" {
  type        = string
  description = "Password for MongoDB mongoadmin and PMM monitoring users. Auto-generated if null."
  default     = null
  sensitive   = true
}

variable "pmm_client_image" {
  type        = string
  description = "PMM client Docker image to run inside DB node client containers"
  default     = "perconalab/pmm-client:3.8.0-rc"
}

variable "pmm_clients_per_db" {
  type        = number
  description = "Number of PMM client containers to launch per DB node"
  default     = 10
}

variable "metrics_mode" {
  type        = string
  description = "pmm-agent metrics mode (auto, push, pull)"
  default     = "auto"
}

variable "mysql_count" {
  type        = number
  description = "Number of MySQL instances to launch"
  default     = 0
}

variable "postgres_count" {
  type        = number
  description = "Number of PostgreSQL instances to launch"
  default     = 0
}

variable "mongo_count" {
  type        = number
  description = "Number of MongoDB instances to launch"
  default     = 0
}

variable "mysql_image" {
  type        = string
  description = "Docker image for the MySQL server container"
  default     = "percona/percona-server:8.0"
}

variable "postgres_image" {
  type        = string
  description = "Docker image for the PostgreSQL server container"
  default     = "percona/percona-distribution-postgresql:17.9"
}

variable "mongo_image" {
  type        = string
  description = "Docker image for the MongoDB server container"
  default     = "percona/percona-server-mongodb:7.0"
}
