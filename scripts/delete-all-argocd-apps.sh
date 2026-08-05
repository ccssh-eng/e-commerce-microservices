#!/bin/bash
echo "Deleting ArgoCD applications..."
argocd app delete --all
