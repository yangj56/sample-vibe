#!/usr/bin/env bash
set -euo pipefail
NS=temporal

helm uninstall temporal --namespace "$NS" --wait 2>/dev/null || true
helm uninstall temporal-pg --namespace "$NS" --wait 2>/dev/null || true

echo "Helm releases removed from ${NS}. Delete the namespace if you want a clean slate:"
echo "  kubectl delete namespace ${NS}"
