resource "local_sensitive_file" "kubeconfig" {
  filename       = ".temp/kubeconfig"
  content_base64 = linode_lke_cluster.harperdb-cluster.kubeconfig
}

provider "helm" {
  kubernetes {
    config_path = local_sensitive_file.kubeconfig.filename
  }
}

resource "helm_release" "linkerd-crds" {
  name = "linkerd-crds"

  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd-crds"
  # version    = "2.12.3"

  atomic           = true
  namespace        = "linkerd"
  create_namespace = true
}

resource "helm_release" "linkerd-control-plane" {
  name = "linkerd-control-plane"

  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd-control-plane"
  # version    = "2.12.3"

  atomic    = true
  namespace = "linkerd"

  set_sensitive {
    name  = "identityTrustAnchorsPEM"
    value = tls_self_signed_cert.trustanchor_cert.cert_pem
  }

  set_sensitive {
    name  = "identity.issuer.tls.crtPEM"
    value = tls_locally_signed_cert.issuer_cert.cert_pem
  }

  set_sensitive {
    name  = "identity.issuer.tls.keyPEM"
    value = tls_private_key.issuer_key.private_key_pem
  }
}

# resource "helm_release" "linkerd-viz" {
#   name             = "linkerd-viz"
#   chart            = "linkerd-viz"
#   namespace        = "linkerd-viz"
#   create_namespace = true
#   repository       = "https://helm.linkerd.io/stable"
#   # version    = "2.12.3"
# }
