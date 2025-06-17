apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: netflix-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/pankajsinghveersatech/DevSecOps-Project-first.git
    targetRevision: HEAD
    path: Kubernetes
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
