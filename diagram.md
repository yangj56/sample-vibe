# Temporal on Kind - network diagram

Topology from `kubectl describe svc`, `kubectl get endpoints`, and `kubectl get pods -o wide` in namespace `temporal`.

If you only see a **code block** below: Cursor and VS Code Markdown preview only renders Mermaid when you install an extension such as **Markdown Preview Mermaid Support**. GitHub renders `mermaid` fenced blocks on push.

```mermaid
flowchart TB
  subgraph cluster["Kind cluster temporal namespace"]
    subgraph node["Node sample-vibe-control-plane"]
      subgraph svc["ClusterIP to pod ports"]
        FE_SVC["temporal-frontend 10.96.193.244 7233 rpc 7243 http"]
        WEB_SVC["temporal-web 10.96.61.46 8080 http"]
        PG_SVC["temporal-pg-postgresql 10.96.67.56 5432 postgres"]
      end

      subgraph pods["Pods ports from endpoints"]
        FE["temporal-frontend 10.244.0.9 7233 rpc 7243 http 9090 6933 hl"]
        WEB["temporal-web 10.244.0.13 8080 http"]
        HIS["temporal-history 10.244.0.14 7234 9090 6934"]
        MAT["temporal-matching 10.244.0.12 7235 9090 6935"]
        WRK["temporal-worker 10.244.0.10 9090 6939"]
        PG["postgresql-0 10.244.0.6 5432"]
      end

      subgraph hl["Headless discovery"]
        HL_FE["frontend-headless"]
        HL_HIS["history-headless"]
        HL_MAT["matching-headless"]
        HL_WRK["worker-headless"]
        HL_PG["postgresql-hl"]
      end
    end
  end

  FE_SVC -->|7233 7243| FE
  WEB_SVC -->|8080| WEB
  PG_SVC -->|5432| PG

  HL_FE -.->|9090 7233 6933| FE
  HL_HIS -.->|9090 7234 6934| HIS
  HL_MAT -.->|7235 9090 6935| MAT
  HL_WRK -.->|9090 6939| WRK
  HL_PG -.->|5432| PG
```

## ClusterIP reference

| Service                  | ClusterIP      | Service ports -> pod       |
|--------------------------|----------------|----------------------------|
| temporal-frontend        | 10.96.193.244  | 7233 7243 -> `10.244.0.9` |
| temporal-web             | 10.96.61.46    | 8080 -> `10.244.0.13`      |
| temporal-pg-postgresql   | 10.96.67.56    | 5432 -> `10.244.0.6`       |

## Headless endpoints reference

| Service                     | Pod IP      | Ports              |
|-----------------------------|-------------|--------------------|
| temporal-frontend-headless  | 10.244.0.9  | 9090 7233 6933     |
| temporal-history-headless   | 10.244.0.14 | 9090 7234 6934     |
| temporal-matching-headless  | 10.244.0.12 | 7235 9090 6935     |
| temporal-worker-headless    | 10.244.0.10 | 9090 6939          |
| temporal-pg-postgresql-hl   | 10.244.0.6  | 5432               |

**Note:** Pod and ClusterIP addresses change after redeploys; refresh from the cluster if this doc drifts.
