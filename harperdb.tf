resource "helm_release" "harperdb" {
  name = "harperdb"

  # repository = "https://helm.linkerd.io/stable"
  chart = "${path.module}/harperdb"
  # version    = "2.12.3"

  atomic           = false
  namespace        = "harperdb"
  create_namespace = true
}
