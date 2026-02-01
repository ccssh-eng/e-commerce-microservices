 Microservices Project

Ce projet implémente une architecture microservices complète basée sur Node.js, conteneurisée avec Docker, orchestrée via Kubernetes, et déployée avec Helm, ArgoCD et Terraform.

Il inclut plusieurs services métiers, un frontend, une base de données MongoDB, un système d’ingress NGINX, du monitoring, et une approche GitOps.

---------------------------------- Architecture globale ----------------------------------------

- Backend : microservices Node.js (Express)
- Frontend : application web servie via NGINX
- Base de données : MongoDB
- Conteneurisation : Docker / Docker Compose
- Orchestration : Kubernetes
- Packaging K8s : Helm
- GitOps : ArgoCD
- Infrastructure : Terraform
- Ingress : NGINX Ingress Controller
- Monitoring : Grafana

--------- Structure du projet --------------
.
├── auth-service 		# Service d'authentification
├── cart-service 		# Gestion du panier
├── inventory-service		# Gestion des stocks
├── order-service 		# Gestion des commandes
├── payment-service 		# Paiements
├── product-service 		# Catalogue produits
├── notification-service 	# Notifications
├── frontend 			# Application frontend (NGINX)
├── mongodb 			# Déploiement MongoDB (K8s)
├── k8s 			# Manifests Kubernetes par service
├── helm 			# Charts Helm (ingress, cert-manager…)
├── auth-chart 		# Chart Helm dédié à auth-service
├── nginx 			# Configuration NGINX
├── scripts 			# Scripts d'automatisation (CI/CD, ArgoCD)
├── terraform 		# Infrastructure as Code
├── docker-compose.yml 	# Lancement local
└── README.md

------------- Microservices -------------

Chaque microservice :
- est écrit en Node.js
- possède son propre Dockerfile
- expose une API REST
- est déployé indépendamment sur Kubernetes

--- Services disponibles ---
- auth-service
- cart-service
- inventory-service
- order-service
- payment-service
- product-service
- notification-service

--- Lancement en local (Docker Compose) ---

--- Prérequis ---
- Docker
- Docker Compose
- Node.js (optionnel pour dev local)

--- Démarrage ---
docker-compose up –build .
Les services seront accessibles via les ports définis dans docker-compose.yml.

Déploiement Kubernetes
Prérequis
-	Kubernetes (Minikube, Kind, EKS, etc.)
-	kubectl
-	Helm
-	ArgoCD (optionnel mais recommandé)
Déploiement manuel
kubectl apply -f k8s/
Déploiement via Helm
helm install auth-service ./auth-chart

GitOps avec ArgoCD
Le dossier k8s/argocd contient la configuration ArgoCD.
Scripts utiles :
scripts/create-all-argocd-apps.sh
scripts/sync-all-argocd-apps.sh
scripts/delete-all-argocd-apps.sh

Monitoring
-	Grafana est exposé via :
grafana-ingress.yaml
Possibilité d’ajouter Prometheus selon les besoins.

 Infrastructure avec Terraform
Le dossier terraform/ permet de gérer l’infrastructure cloud :
cd terraform
terraform init
terraform apply

Sécurité & Secrets
-	Les secrets Kubernetes sont stockés dans :
k8s/secrets/
mongodb/mongodb-secret.yaml
En production, utiliser un Secret Manager (AWS, Vault, etc.)

Tests
Chaque service peut être testé individuellement :
cd auth-service
npm install
npm test

 Bonnes pratiques appliquées
-	Séparation des responsabilités
-	Scalabilité par microservice
-	Déploiement indépendant
-	GitOps
-	Infrastructure as Code
-	Conteneurisation complète

Auteur
Projet développé par ccssh-eng (Cédric)
Dans un but d’apprentissage / démonstration d’une architecture microservices moderne.
