#  Projet: E-Commerce Microservices Platforme 

> Plateforme e-commerce complètement basée sur une architecture microservices,
> conteneurisée avec Docker, orchestrée via Kubernetes (AKS) et déployée
> en GitOps avec ArgoCD sur Microsoft Azure.

## Table des matières

- [Architecture](#architecture)
- [Microservices](#microservices)
- [Technologies](#technologies)
- [Démarrage rapide](#démarrage-rapide)
- [Déploiement Kubernetes](#déploiement-kubernetes)
- [GitOps avec ArgoCD](#gitops-avec-argocd)
- [Monitoring](#monitoring)
- [Infrastructure Terraform](#infrastructure-terraform)
- [Structure du projet](#structure-du-projet)

## Architecture
                                                    ##  E-COMMERCE MICROSERVICES
                                                    ##       Microsoft Azure

### Flux de données

1. Utilisateur -> React Frontend (port 3000)
2. Frontend -> NGINX Gateway (port 8081)
3. NGINX route vers le microservice approprié
4. Microservice <- -> MongoDB / CosmosDB
5. Réponse -> Frontend -> Utilisateur

## Microservices

| Service | Port | Rôle | Technologie |

| **auth-service** | 3001 | Authentification JWT | Node.js, bcryptjs, jsonwebtoken |
| **product-service** | 3002 | Catalogue produits | Node.js, Express |
| **order-service** | 3003 | Gestion des commandes | Node.js, MongoDB |
| **cart-service** | 3004 | Panier d'achat | Node.js, MongoDB |
| **payment-service** | 3005 | Traitement des paiements | Node.js, Express |
| **inventory-service** | 3006 | Gestion des stocks | Node.js, MongoDB |
| **notification-service** | 3007 | Notifications | Node.js, Express |
| **frontend** | 3000 | Interface utilisateur React | React 19, NGINX |
| **nginx** | 8081 | API Gateway / Reverse Proxy | NGINX |
| **mongo** | 27017 | Base de données | MongoDB |

### Endpoints API

POST /login          -> auth-service   : Authentification, retourne JWT
GET  /products      -> product-service: Liste des produits
GET  /orders         -> order-service  : Liste des commandes
GET  /cart            -> cart-service   : Contenu du panier
POST /payment      ->   payment-service: Traitement paiement
GET  /inventory     -> inventory-service: Niveaux de stock
GET  /notifications  -> notification-service: Notifications

GET  /health         -> Disponible sur chaque service

## Technologies

BACKEND           Node.js 18+ / Express
FRONTEND          React 19 / NGINX
BASE DE DONNÉES   MongoDB 6
CONTENEURS        Docker / Docker Compose
ORCHESTRATION     Kubernetes
REGISTRY          Azure Container Registry (ACR)
PACKAGING K8S     Helm
GITOPS            ArgoCD
GATEWAY           NGINX Ingress Controller
MONITORING        Grafana + Prometheus
IaC               Terraform (provider azurerm ~> 3.100)
CI/CD             GitHub Actions

## Démarrage rapide
### Prérequis

docker --version        # >= 24.0
docker compose version  # >= 2.0
node --version          # >= 18 (optionnel pour dev)

### Lancer avec Docker Compose
# Cloner le repo

git clone https://github.com/ccssh-eng/e-commerce-microservices.git
cd e-commerce-microservices

# Démarrer tous les services

docker compose up --build

# En arrière-plan

docker compose up --build -d

# Voir les logs

docker compose logs -f

### Services accessibles

Frontend            -> http://localhost:3000
NGINX Gateway       -> http://localhost:8081
Auth Service        -> http://localhost:3001
Product Service     -> http://localhost:3002
Order Service       -> http://localhost:3003
Cart Service        -> http://localhost:3004
Payment Service     -> http://localhost:3005
Inventory           -> http://localhost:3006
Notification        -> http://localhost:3007
MongoDB             -> localhost:27017

### Test rapide
# Health check sur tous les services

curl http://localhost:3001/health  # Auth OK
curl http://localhost:3002/health  # Product OK

# Login -> retourne un JWT

curl -X POST http://localhost:3001/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"password"}'

# Liste des produits

curl http://localhost:3002/products

# Health check de tous les services
./scripts/health-check.sh

### Arrêter les services

docker compose down

# Supprimer aussi les volumes MongoDB

docker compose down -v

## Déploiement Kubernetes
### Prérequis

az --version      # Azure CLI
kubectl version   # >= 1.28
helm version      # >= 3.0

### Connexion au cluster AKS
# Login Azure

az login

# Récupérer les credentials AKS

az aks get-credentials \
  --resource-group rg-ecommerce-microservices \
  --name aks-ecommerce

# Vérifier la connexion

kubectl get nodes

### Déploiement manuel
# Appliquer tous les manifests

kubectl apply -f k8s/

# Vérifier les pods

kubectl get pods
kubectl get services
kubectl get ingress

### Déploiement via Helm

# Installer le chart auth-service

helm install auth-service ./auth-chart

# Lister les releases

helm list

# Mettre à jour

helm upgrade auth-service ./auth-chart

# Désinstaller

helm uninstall auth-service

### Push des images vers ACR

# Login ACR

az acr login --name acrecommerce

# Build et push de chaque service

for SERVICE in auth-service product-service order-service \
               cart-service payment-service inventory-service \
               notification-service frontend; do
  az acr build \
    --registry acrecommerce \
    --image $SERVICE:latest \
    --file $SERVICE/Dockerfile \
    ./$SERVICE
done

## GitOps avec ArgoCD

Le projet suit une approche **GitOps** — chaque changement dans le repo Git
déclenche automatiquement le déploiement sur AKS via ArgoCD.

Git Push -> ArgoCD détecte -> Sync automatique -> AKS

### Installation ArgoCD sur AKS

kubectl create namespace argocd

kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Accéder à l'UI ArgoCD

kubectl port-forward svc/argocd-server -n argocd 8080:443

# URL : https://localhost:8080

### Scripts disponibles

# Créer toutes les applications ArgoCD

./scripts/create-all-argocd-apps.sh

# Synchroniser toutes les applications

./scripts/sync-all-argocd-apps.sh

# Vérifier la santé de tous les services

./scripts/health-check.sh

# Supprimer toutes les applications

./scripts/delete-all-argocd-apps.sh

## Monitoring

Grafana est exposé via `grafana-ingress.yaml` pour la visualisation des métriques.

# Accéder à Grafana

kubectl port-forward svc/grafana 3000:3000 -n monitoring

# URL : http://localhost:3000
# Login par défaut : admin / admin

Métriques surveillées :
- Latence des requêtes par microservice
- Nombre de requêtes par endpoint
- Utilisation CPU / Mémoire par pod
- Disponibilité des services (health checks)
- Taux d'erreur par service

## Infrastructure Azure Terraform

Le dossier `terraform/` provisionne l'infrastructure Azure complète :

| Ressource | Service Azure |

| Cluster Kubernetes | Azure Kubernetes Service (AKS) |
| Registry Docker | Azure Container Registry (ACR) |
| Base de données | Azure CosmosDB (MongoDB API) |
| Réseau | Azure Virtual Network |

cd terraform

# Login Azure

az login

# Initialiser Terraform

terraform init

# Planifier

terraform plan

# Appliquer

terraform apply

# Outputs utiles

terraform output aks_cluster_name
terraform output acr_login_server


## Structure du projet

e-commerce-microservices/
│
├── auth-service/              # Authentification JWT (port 3001)
│   ├── Dockerfile
│   ├── index.js               # POST /login, GET /health
│   └── package.json           # bcryptjs, jsonwebtoken, express
│
├── product-service/           # Catalogue produits (port 3002)
│   ├── Dockerfile
│   ├── index.js               # GET /products, GET /health
│   └── package.json
│
├── order-service/             # Gestion commandes (port 3003)
├── cart-service/              # Panier d'achat (port 3004)
├── payment-service/           # Paiements (port 3005)
├── inventory-service/         # Stocks (port 3006)
├── notification-service/      # Notifications (port 3007)
│
├── frontend/                  # React 19 + NGINX (port 3000)
│   ├── Dockerfile
│   ├── src/App.js             # Consomme GET /api/products
│   └── package.json
│
├── k8s/                       # Manifests Kubernetes
│   ├── auth-service/
│   ├── frontend/
│   ├── nginx-gateway/
│   └── product-service/
│
├── terraform/                 # Infrastructure as Code (Azure)
│   ├── main.tf                # AKS + ACR + CosmosDB
│   ├── variables.tf           # Variables d'entrée
│   └── outputs.tf             # Valeurs exportées
│
├── scripts/                   # Scripts d'automatisation
│   ├── create-all-argocd-apps.sh
│   ├── sync-all-argocd-apps.sh
│   ├── delete-all-argocd-apps.sh
│   └── health-check.sh
│
├── nginx/
│   └── default.conf           # Configuration API Gateway
│
├── mongo-seeder/              # Initialisation données MongoDB
├── docker-compose.yml         # Orchestration locale complète
└── README.md

## Auteur

**Cédric SH**
*Architecte Cloud Azure | Ingénieur DevOps | Développeur Full Stack*

