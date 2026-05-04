# Temporal on kind (local Kubernetes)

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (or another kind-supported container runtime)
- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm 3](https://helm.sh/docs/intro/install/)

## One-shot bootstrap

From this directory:

```bash
./bootstrap.sh
```

This creates a cluster named **`sample-vibe`** (override with `KIND_CLUSTER_NAME=my-cluster`) and installs PostgreSQL + Temporal into namespace `temporal`.

## Connect from your Mac

Services use **ClusterIP**; use port-forward:

```bash
./port-forward.sh
```

Then:

- **gRPC / SDKs:** `localhost:7233`, namespace `default`
- **Web UI:** http://localhost:8080

## Individual steps

| Script | Action |
|--------|--------|
| `./create-cluster.sh` | `kind create cluster` (skips if cluster exists) |
| `../k8s/install.sh` | Helm: Bitnami Postgres + Temporal |
| `./port-forward.sh` | `kubectl port-forward` for frontend + UI |
| `./delete-cluster.sh` | `kind delete cluster` |

## Tear down

```bash
../k8s/uninstall.sh          # removes Helm releases (namespace may remain)
./delete-cluster.sh          # deletes the kind cluster
kubectl delete namespace temporal   # optional full cleanup
```

## Notes

- If Docker is tight on RAM, raise Docker Desktop memory before installing Temporal.
- Another cluster named `sample-vibe` cannot exist; pick a different `KIND_CLUSTER_NAME` if it conflicts.
