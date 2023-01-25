resource "linode_lke_cluster" "harperdb-cluster" {
  label       = "harperdb-cluster"
  k8s_version = "1.25"
  region      = "us-central"
  tags        = ["prod", "database"]

  pool {
    type  = "g6-standard-2"
    count = 3
  }
}
