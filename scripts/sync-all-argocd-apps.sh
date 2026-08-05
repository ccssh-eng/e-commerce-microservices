#!/bin/bash
echo "Syncing ArgoCD applications..."
argocd app sync --all
