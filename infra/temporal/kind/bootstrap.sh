#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"${DIR}/create-cluster.sh"
"${DIR}/../k8s/install.sh"

echo ""
echo "Next: expose gRPC + Web UI to your Mac (keep this running):"
echo "  ${DIR}/port-forward.sh"
echo "Then use localhost:7233 (workers/SDKs) and http://localhost:8080 (UI)."
