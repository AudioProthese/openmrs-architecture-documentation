# Initialisation dans Azure

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
```

## 2. 🔐 Configuration de la connexion OIDC sécurisée

L'authentification OIDC (OpenID Connect) permet à GitHub Actions d'accéder à Azure sans stocker de secrets dans le dépôt.
Pour notre architecture, nous configurons deux connexions OIDC distinctes:
- Une pour le dépôt d'**infrastructure** (terraform, IaC)
- Une pour le dépôt d'**application** (code applicatif)

```bash

#!/bin/bash
set -e  

configure_oidc() {
    local app_name=$1
    local github_org=$2
    local github_repo=$3
    local github_env=$4
    local federated_name=$5
    
    echo "====== Configuration OIDC pour $app_name ======"
    echo "🔄 Création de l'application Azure AD..."
    local app_id=$(az ad app create --display-name "$app_name" --query appId -o tsv)
    echo "✅ Application créée: $app_id"

    echo "🔄 Création du Service Principal..."
    local sp_object_id=$(az ad sp create --id "$app_id" --query id -o tsv)
    echo "👤 Service Principal créé avec Object ID: $sp_object_id"

    local subject="repo:${github_org}/${github_repo}:environment:${github_env}"
    echo "🔄 Configuration des identifiants fédérés pour GitHub Actions..."
    az ad app federated-credential create --id "$app_id" \
      --parameters '{
        "name": "'"$federated_name"'",
        "issuer": "https://token.actions.githubusercontent.com",
        "subject": "'"$subject"'",
        "description": "GitHub OIDC pour '"$github_env"'",
        "audiences": ["api://AzureADTokenExchange"]
      }'
    echo "🔗 Identifiants fédérés ajoutés pour: $subject"

    echo "🔄 Attribution des autorisations..."
    az role assignment create \
      --assignee "$app_id" \
      --role "Owner" \
      --scope "/subscriptions/$SUBSCRIPTION_ID"
    echo "🔑 Rôle 'Owner' attribué à l'application sur l'abonnement $SUBSCRIPTION_ID"

    echo "$app_id"
}

if ! az account show > /dev/null 2>&1; then
  echo "🔐 Vous n'êtes pas connecté à Azure CLI. Connexion..."
  az login
else
  echo "✅ Déjà connecté à Azure CLI."
fi

TIMESTAMP=$(date +%Y%m%d%H%M%S)
GITHUB_ORG="AudioProthese"
GITHUB_ENV="dev"
SUBSCRIPTION_ID="c2b90606-cc96-463f-aa06-70f32719fe4f"

INFRA_APP_NAME="Github-OIDC-Infra-${TIMESTAMP}"
INFRA_GITHUB_REPO="openmrs-core-infrastructure"
INFRA_FEDERATED_NAME="Infra"

APP_APP_NAME="Github-OIDC-App-${TIMESTAMP}"
APP_GITHUB_REPO="openmrs-distro-referenceapplication"
APP_FEDERATED_NAME="Application"

echo -e "\n🌍 CONFIGURATION POUR L'INFRASTRUCTURE"
INFRA_APP_ID=$(configure_oidc "$INFRA_APP_NAME" "$GITHUB_ORG" "$INFRA_GITHUB_REPO" "$GITHUB_ENV" "$INFRA_FEDERATED_NAME")

echo -e "\n📦 CONFIGURATION POUR L'APPLICATION"
APP_APP_ID=$(configure_oidc "$APP_APP_NAME" "$GITHUB_ORG" "$APP_GITHUB_REPO" "$GITHUB_ENV" "$APP_FEDERATED_NAME")

echo -e "\n📋 RÉCAPITULATIF DES CONFIGURATIONS"
echo -e "\n=== POUR L'INFRASTRUCTURE ($INFRA_GITHUB_REPO) ==="
echo "  - AZURE_CLIENT_ID: $INFRA_APP_ID"
echo "  - AZURE_TENANT_ID: $(az account show --query tenantId -o tsv)"
echo "  - AZURE_SUBSCRIPTION_ID: $SUBSCRIPTION_ID"

echo -e "\n=== POUR L'APPLICATION ($APP_GITHUB_REPO) ==="
echo "  - AZURE_CLIENT_ID: $APP_APP_ID"
echo "  - AZURE_TENANT_ID: $(az account show --query tenantId -o tsv)"
echo "  - AZURE_SUBSCRIPTION_ID: $SUBSCRIPTION_ID"

echo -e "\n🎉 Configuration OIDC terminée avec succès pour les deux applications."

```

### Avantages de l'authentification OIDC

L'utilisation de la fédération d'identité (OIDC) avec GitHub Actions et Azure présente plusieurs avantages critiques :

- **Sécurité renforcée** : Élimine le besoin de stocker des secrets à longue durée de vie dans GitHub
- **Rotation automatique** : Les jetons sont générés à la demande et ont une durée de vie limitée
- **Accès contextuel** : L'accès peut être limité à des branches ou environnements spécifiques
- **Audit simplifié** : Meilleure traçabilité des opérations effectuées par les workflows CI/CD
- **Réduction des risques** : Minimise l'impact potentiel en cas de compromission du référentiel


## 📚 Ressources additionnelles

- [Documentation Azure sur l'authentification OIDC pour GitHub Actions](https://docs.microsoft.com/en-us/azure/developer/github/connect-from-azure)