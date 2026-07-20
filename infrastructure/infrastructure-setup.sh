#!/bin/bash
set -e

echo "Starting minikube cluster with docker driver;"
minikube start --driver=docker --cpus=4 --memory=6144

#reference:Artifacthub
echo "Adding public helm repos;"
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

echo "Deploying ArgoCD;"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  -f argocd-values.yaml

echo "Deploying Prometheus and Grafana;"
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  -f monitoring-values.yaml

#reference:stackoverflow
echo ""
echo "Setup Completed"
echo -n "ArgoCD Password: "
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d || echo "N/A"
echo ""
echo "ArgoCD Username: admin"
echo ""
echo "Access dashboards:"
echo "  ArgoCD Portal : minikube service argocd-server -n argocd"
echo "  Grafana Portal: kubectl port-forward svc/prometheus-grafana -n monitoring 3000:80"