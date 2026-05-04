#!/usr/bin/env bash
# Installs PostgreSQL + Temporal into namespace "temporal" via Helm.
#
# Prerequisite: kubectl must point at a working cluster (kubectl config use-context …).
# You do NOT have to run kind/bootstrap.sh if you already have a cluster (kind, EKS, OrbStack, etc.).
# Run ../kind/bootstrap.sh only when you want this repo to create a fresh kind cluster, then install.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NS=temporal

if ! kubectl cluster-info >/dev/null 2>&1; then
  echo "kubectl cannot use a cluster (no context, wrong KUBECONFIG, or cluster not running)."
  if ! kubectl config current-context >/dev/null 2>&1; then
    echo "  → No current context. Pick one: kubectl config get-contexts && kubectl config use-context <name>"
  fi
  echo "  → For kind from this repo: cd \"${ROOT}/../kind\" && ./bootstrap.sh"
  exit 1
fi

echo "kubectl context: $(kubectl config current-context)"
echo "Installing Helm releases into namespace ${NS} …"

kubectl get namespace "$NS" >/dev/null 2>&1 || kubectl create namespace "$NS"

helm repo add bitnami https://charts.bitnami.com/bitnami >/dev/null 2>&1 || true
helm repo update bitnami >/dev/null

echo "Installing PostgreSQL (Bitnami)..."
helm upgrade --install temporal-pg bitnami/postgresql \
  --namespace "$NS" \
  --wait --timeout 15m \
  -f "$ROOT/postgres-values.yaml"

echo "Installing Temporal (official Helm chart)..."
helm repo add temporal https://go.temporal.io/helm-charts >/dev/null 2>&1 || true
helm repo update temporal >/dev/null

# Chart must be referenced as temporal/temporal from the added repo (not --repo on this line).
helm upgrade --install temporal temporal/temporal \
  --namespace "$NS" \
  --wait --timeout 25m \
  -f "$ROOT/temporal-values.yaml"

echo ""
echo "Done. Services in namespace ${NS}:"
kubectl get svc -n "$NS"
echo ""
echo "Expose services on localhost (ClusterIP services need port-forward):"
echo "  ../kind/port-forward.sh"
echo "Or manually:"
echo "  kubectl port-forward -n ${NS} svc/temporal-frontend 7233:7233"
echo "  kubectl port-forward -n ${NS} svc/temporal-web 8080:8080"
