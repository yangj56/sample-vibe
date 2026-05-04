#!/usr/bin/env bash
# Forward Temporal frontend (7233) and Web UI (8080) to localhost. Ctrl+C stops both.
set -euo pipefail
NS=temporal
pids=()

cleanup() {
  for pid in "${pids[@]:-}"; do
    kill "$pid" 2>/dev/null || true
  done
}
trap cleanup EXIT INT TERM

kubectl port-forward -n "$NS" svc/temporal-frontend 7233:7233 &
pids+=("$!")
kubectl port-forward -n "$NS" svc/temporal-web 8080:8080 &
pids+=("$!")

echo "Forwarding temporal-frontend:7233 -> localhost:7233"
echo "Forwarding temporal-web:8080 -> localhost:8080"
echo "Press Ctrl+C to stop."
wait
