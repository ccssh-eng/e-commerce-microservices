#  E-Commerce Microservices Platforme

![Node.js](https://img.shields.io/badge/Node.js-18+-339933?logo=node.js)
![React](https://img.shields.io/badge/React-19-61DAFB?logo=react)
![MongoDB](https://img.shields.io/badge/MongoDB-6-47A248?logo=mongodb)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Orchestration-326CE5?logo=kubernetes)
![Helm](https://img.shields.io/badge/Helm-Charts-0F1689?logo=helm)
![ArgoCD](https://img.shields.io/badge/ArgoCD-GitOps-EF7B4D?logo=argo)
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform)
![NGINX](https://img.shields.io/badge/NGINX-Gateway-009639?logo=nginx)
![Grafana](https://img.shields.io/badge/Grafana-Monitoring-F46800?logo=grafana)

> Plateforme e-commerce complète basée sur une architecture microservices,
> conteneurisée avec Docker, orchestrée via Kubernetes et déployée en GitOps avec ArgoCD.

##  Table des matières

- [Architecture](#architecture)
- [Microservices](#microservices)
- [Technologies](#technologies)
- [Démarrage rapide](#démarrage-rapide)
- [Déploiement Kubernetes](#déploiement-kubernetes)
- [GitOps avec ArgoCD](#gitops-avec-argocd)
- [Monitoring](#monitoring)
- [Infrastructure Terraform](#infrastructure-terraform)
- [Structure du projet](#structure-du-projet)

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
BACKEND                Node.js 18+ / Express
FRONTEND              React 19 / NGINX
BASE DE DONNÉES   MongoDB 6
CONTENEURS          Docker / Docker Compose
ORCHESTRATION     Kubernetes
PACKAGING K8S       Helm
GITOPS                    ArgoCD
GATEWAY                NGINX Ingress Controller
MONITORING          Grafana + Prometheus
IaC                          Terraform
CI/CD                      GitHub Actions

## Démarrage rapide
### Prérequis
docker --version        # >= 24.0
docker compose version  # >= 2.0
node --version          # >= 18 (optionnel)

### Lancer avec Docker Compose
# Cloner le repo
git clone https://github.com/ccssh-eng/e-commerce-microservices.git
cd e-commerce-microservices

# Démarrer tous les services
docker compose up --build

# En arrière-plan
docker compose up --build -d

### Services accessibles
Frontend            -> http://localhost:3000
NGINX Gateway  -> http://localhost:8081
Auth Service        -> http://localhost:3001
Product Service    -> http://localhost:3002
Order Service      -> http://localhost:3003
Cart Service        -> http://localhost:3004
Payment Service   -> http://localhost:3005
Inventory            -> http://localhost:3006
Notification         -> http://localhost:3007
MongoDB           -> localhost:27017

### Test rapide
# Health check sur tous les services
curl http://localhost:3001/health  # Auth OK
curl http://localhost:3002/health  # Product OK

# Login
curl -X POST http://localhost:3001/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"password"}'

# Liste des produits
curl http://localhost:3002/products

### Arrêter les services
docker compose down

# Supprimer aussi les volumes MongoDB
docker compose down -v

## Déploiement Kubernetes

### Prérequis
kubectl version    # >= 1.28
helm version       # >= 3.0

### Déploiement manuel
# Appliquer tous les manifests
kubectl apply -f k8s/

# Vérifier les pods
kubectl get pods
kubectl get services

### Déploiement via Helm
# Installer le chart auth-service
helm install auth-service ./auth-chart

# Lister les releases
helm list

# Mettre à jour
helm upgrade auth-service ./auth-chart

# Désinstaller
helm uninstall auth-service

## GitOps avec ArgoCD

Le projet suit une approche **GitOps** - chaque changement dans le repo Git
déclenche automatiquement le déploiement sur Kubernetes via ArgoCD.

Git Push -> ArgoCD détecte le changement -> Sync -> Kubernetes

### Installation ArgoCD

kubectl create namespace argocd
kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

### Scripts disponibles
# Créer toutes les applications ArgoCD
./scripts/create-all-argocd-apps.sh

# Synchroniser toutes les applications
./scripts/sync-all-argocd-apps.sh

# Supprimer toutes les applications
./scripts/delete-all-argocd-apps.sh

## Monitoring

Grafana est exposé via `grafana-ingress.yaml` pour la visualisation des métriques.
# Accéder à Grafana
kubectl port-forward svc/grafana 3000:3000 -n monitoring

# URL : http://localhost:3000
# Login par défaut : admin / admin

Métriques disponibles :
- Latence des requêtes par service
- Nombre de requêtes par endpoint
- Utilisation CPU / Mémoire par pod
- Disponibilité des services (health checks)

## Infrastructure Terraform
Le dossier `terraform/` gère le provisionnement de l'infrastructure cloud.

cd terraform

# Initialiser
terraform init

# Planifier
terraform plan

# Appliquer
terraform apply

# Détruire
terraform destroy

## Structure du projet
~/e-commerce-microservices$ tree -L 2
.
├── Dockerfile
├── README.md
├── auth-service                                # Authentification JWT (port 3001)
│   ├── Dockerfile
│   ├── db.json
│   ├── index.js
│   ├── node_modules
│   ├── package-lock.json
│   └── package.json
├── cart-service                                    # Panier d'achat (port 3004)
│   ├── Dockerfile
│   ├── db.json
│   ├── index.js
│   ├── node_modules
│   ├── package-lock.json
│   └── package.json
├── docker-compose.yml                     # Orchestration locale
├── frontend                                      # React 19 + NGINX (port 3000)
│   ├── Dockerfile
│   ├── README.md
│   ├── node_modules
│   ├── package-lock.json
│   ├── package.json
│   ├── public
│   └── src                                        # Consomme l'API /api/products
├── index.js
├── inventory-service                           # Stocks (port 3006)
│   ├── Dockerfile
│   ├── db.json
│   ├── index.js
│   ├── node_modules
│   ├── package-lock.json
│   └── package.json
├── k8s                                           # Manifests Kubernetes
│   ├── auth-service
│   ├── frontend
│   ├── nginx-gateway
│   └── product-service
├── mongo-seeder                             # Initialisation données MongoDB
│   ├── Dockerfile
│   ├── node_modules
│   ├── package-lock.json
│   ├── package.json
│   └── seed.js
├── nginx
│   └── default.conf                             # Configuration API Gateway
├── node_modules/
├── notification-service                          # Notifications (port 3007)
│   ├── Dockerfile
│   ├── db.json
│   ├── index.js
│   ├── node_modules
│   ├── package-lock.json
│   └── package.json
├── order-service                                   # Gestion commandes (port 3003)
│   ├── Dockerfile
│   ├── db.json
│   ├── index.js
│   ├── node_modules
│   ├── package-lock.json
│   └── package.json
├── package-lock.json
├── package.json
├── payment-service                                 # Paiements (port 3005)
│   ├── Dockerfile
│   ├── index.js
│   ├── node_modules
│   ├── package-lock.json
│   └── package.json
└── product-service                                 # Catalogue produits (port 3002)
    ├── Dockerfile
    ├── app.js
    ├── db.json
    ├── index.js
    ├── node_modules
    ├── package-lock.json
    ├── package.json
    └── server.js
111 directories, 51 files

## Auteur
**Cédric SH**
*Architecte Cloud | Ingénieur DevOps | Développeur Full Stack*

[![GitHub](https://img.shields.io/badge/GitHub-ccssh--eng-181717?logo=github)]
