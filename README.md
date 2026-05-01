# keycloak-poc

Proof of concept for centralised identity and single sign-on (SSO) using [Keycloak](https://www.keycloak.org/), deployed on a single-node k3s Kubernetes cluster.

## What's in this repo

### `Containerfile`
Multi-stage build that produces a custom Keycloak image with the `adv-tech` theme baked in. Built and pushed to `ghcr.io/pberkel/keycloak-poc` via GitHub Actions on every push to `main` that touches the `Containerfile` or `themes/`.

### `themes/adv-tech/`
Custom Keycloak theme extending the built-in `keycloak.v2` (login), `keycloak.v3` (account console), and `keycloak` (email, admin) parent themes. Only files that differ from the parent are included — templates are inherited, not copied.

| Type | Parent | Customisations |
|---|---|---|
| `login` | `keycloak.v2` | Adventist Technology logo, background, CSS overrides |
| `account` | `keycloak.v3` | Adventist Technology logo, favicon |
| `admin` | `keycloak.v2` | Adventist Technology logo, favicon |
| `email` | `keycloak` | — |
| `welcome` | `keycloak` | — |

### `kubernetes/`
Kubernetes manifests for deploying to k3s with Traefik ingress and Let's Encrypt TLS.

| File | Description |
|---|---|
| `namespace.yaml` | `keycloak-poc` namespace |
| `keycloak.yaml` | Keycloak StatefulSet, Postgres Deployment, Services, PVCs |
| `keycloak-ingress.yaml` | Ingress for `keycloak-poc.pjberkel.com` |
| `account-redirect.yaml` | Traefik middleware redirecting `/account` to the realm account console |
| `traefik-config.yaml` | HelmChartConfig enabling Let's Encrypt via HTTP-01 challenge |
| `gitea.yaml` | Gitea Deployment, Service, PVC (demo SSO application) |
| `gitea-ingress.yaml` | Ingress for `gitea-poc.pjberkel.com` |
| `secrets.yaml.example` | Template for `secrets.yaml` — copy and fill in before applying |

> `secrets.yaml` is gitignored. Copy `secrets.yaml.example` to `secrets.yaml` and fill in passwords before deploying.

## Demo URLs

| | |
|---|---|
| Account portal | https://keycloak-poc.pjberkel.com/realms/adv-tech/account/ |
| Gitea (demo app) | https://gitea-poc.pjberkel.com/ |

## Registration flow

1. User registers with email, first name, and last name
2. Verification email sent — user clicks confirmation link
3. User sets a password
4. Single account gives access to all connected applications (Gitea and any future integrations)
