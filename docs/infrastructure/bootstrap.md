# Initialisation de l'environnement Azure

Cette page décrit les étapes nécessaires à la **mise en place initiale (bootstrap)** de l’environnement Azure pour accueillir :

- Le **backend Terraform (Remote State)** dans un Storage Account
- La **connexion OIDC sécurisée** depuis la CI (ex : GitHub Actions ou GitLab CI)
- Les **ressources d’authentification** (groupes, rôles, permissions minimales)

---

## 🎯 Objectif

- Centraliser l’état Terraform (`terraform.tfstate`) dans un blob Azure sécurisé
- Utiliser **l'authentification OIDC (Workload Identity Federation)** pour éviter l’usage de secrets
- Créer un environnement reproductible pour le provisioning IaC

---

## 1. 📦 Création du Storage Account pour le backend

```bash
RESOURCE_GROUP="rg-terraform-state"
STORAGE_ACCOUNT="stterraform$(openssl rand -hex 3)"
CONTAINER_NAME="tfstate"

az group create --name $RESOURCE_GROUP --location westeurope

az storage account create \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location westeurope \
  --sku Standard_LRS \
  --kind StorageV2 \
  --enable-hierarchical-namespace true

az storage container create \
  --account-name $STORAGE_ACCOUNT \
  --name $CONTAINER_NAME
