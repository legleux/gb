variable "region" {
  default = "us-west1-b"
}

variable "zone" {
  default = "us-west1-b"
}

# your google cloud project ID
variable "project" {
  default = "legleux-test"
}

variable "cluster_name" {
  default = "guestbook"
}

variable "node_count" {
  default = "1"
}

# I have no idea how this implementation is getting "insufficient cpu"
# and it also doesn't look like it actually has insufficient cpu, but I
# upped it anyway
variable "machine_type" {
  default = "n1-standard-2"
}
