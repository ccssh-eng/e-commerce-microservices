# e-commerce-microservices

> A production-grade microservices architecture built with Node.js, Docker, Kubernetes, Helm, ArgoCD and Terraform — designed for scalability, GitOps automation and cloud-native deployment.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                        NGINX Ingress                        │
└──────────┬──────────────────────────────────────────────────┘
           │
    ┌──────▼──────┐
    │   Frontend  │  (NGINX-served web app)
    └──────┬──────┘
           │  REST API calls
    ┌──────▼────────────────────────────────────────┐
    │              Microservices Layer               │
    │                                               │
    │  auth · cart · inventory · order              │
    │  payment · product · notification             │
    └──────────────────┬────────────────────────────┘
                       │
              ┌────────▼────────┐
              │    MongoDB      │
              └─────────────────┘
```

| Layer           | Technology                              |
|-----------------|-----------------------------------------|
| Backend         | Node.js / Express — REST APIs           |
| Frontend        | Static web app served by NGINX          |
| Database        | MongoDB                                 |
| Containerization| Docker / Docker Compose                 |
| Orchestration   | Kubernetes (Minikube / EKS / Kind)      |
| Packaging       | Helm Charts                             |
| GitOps          | ArgoCD                                  |
| Infrastructure  | Terraform                               |
| Ingress         | NGINX Ingress Controller                |
| Monitoring      | Grafana (+ Prometheus-ready)            |

---

## Project Structure

```
e-commerce-microservices/
├── auth-service/          # Authentication & JWT
├── cart-service/          # Shopping cart management
├── inventory-service/     # Stock & inventory
├── order-service/         # Order lifecycle
├── payment-service/       # Payment processing
├── product-service/       # Product catalog
├── notification-service/  # Email / push notifications
├── frontend/              # Web frontend (NGINX)
├── mongodb/               # MongoDB K8s deployment
├── k8s/                   # Kubernetes manifests (per service)
├── helm/                  # Helm charts (ingress, cert-manager…)
├── auth-chart/            # Dedicated Helm chart for auth-service
├── nginx/                 # NGINX configuration
├── scripts/               # Automation scripts (CI/CD, ArgoCD)
├── terraform/             # Infrastructure as Code
├── docker-compose.yml     # Local development launcher
└── README.md
```

---

## Microservices

Each service is independently deployable and follows the same pattern:

- Written in **Node.js** with Express
- Has its own **Dockerfile**
- Exposes a **REST API**
- Is deployed as a separate **Kubernetes pod**

| Service              | Responsibility                  |
|----------------------|---------------------------------|
| `auth-service`       | User authentication, JWT tokens |
| `cart-service`       | Add/remove cart items           |
| `inventory-service`  | Product stock management        |
| `order-service`      | Order creation & tracking       |
| `payment-service`    | Payment gateway integration     |
| `product-service`    | Product catalog & search        |
| `notification-service` | Email & push notifications    |

---

## Getting Started

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) & Docker Compose
- [Node.js](https://nodejs.org/) *(optional — for local dev without Docker)*
- [kubectl](https://kubernetes.io/docs/tasks/tools/) *(for Kubernetes deployment)*
- [Helm](https://helm.sh/docs/intro/install/) *(for Helm-based deployment)*

### Run locally with Docker Compose

```bash
git clone https://github.com/ccssh-eng/e-commerce-microservices.git
cd e-commerce-microservices
docker-compose up --build
```

Services will be available on the ports defined in `docker-compose.yml`.

---

## Kubernetes Deployment

### Manual deployment

```bash
kubectl apply -f k8s/
```

### Helm deployment

```bash
helm install auth-service ./auth-chart
```

---

## GitOps with ArgoCD

ArgoCD configuration lives in `k8s/argocd/`. Convenience scripts are provided:

```bash
scripts/create-all-argocd-apps.sh   # Create all ArgoCD applications
scripts/sync-all-argocd-apps.sh     # Sync all applications
scripts/delete-all-argocd-apps.sh   # Tear down all applications
```

---

## Infrastructure with Terraform

```bash
cd terraform
terraform init
terraform apply
```

---

## Monitoring

Grafana is exposed via `grafana-ingress.yaml`.  
Prometheus can be added as a metrics backend.

---

## Security & Secrets

All services receive their configuration through **environment variables** — no credentials are hardcoded in the source code.

For local development with Docker Compose, connection strings use no authentication (standard for a local dev environment):

MONGO_URI=mongodb://mongo:27017/<service-db>


For production deployment, use a dedicated Secret Manager:
- **Azure Key Vault** (recommended for Azure/AKS deployments)
- **AWS Secrets Manager** (for EKS deployments)  
- **HashiCorp Vault** (cloud-agnostic)
- **Kubernetes Secrets** with RBAC restrictions at minimum

A `.env.example` file is provided as a template — copy it to `.env` and fill in your own values:

```bash
cp .env.example .env
```

> `.env` is listed in `.gitignore` and will never be committed to version control.

---

## Testing

Each service can be tested independently:

```bash
cd auth-service
npm install
npm test
```

---

## Best Practices Applied

- **Separation of concerns** — each service owns its domain
- **Independent deployability** — services scale and deploy separately
- **GitOps** — declarative infrastructure, version-controlled deployments
- **Infrastructure as Code** — Terraform manages all cloud resources
- **Full containerization** — Docker from dev to production

---

## Author

**Cédric SH** — Data Engineer | Cloud | Azure
[github.com/ccssh-eng/e-commerce-microservices](https://github.com/ccssh-eng/e-commerce-microservices)  
