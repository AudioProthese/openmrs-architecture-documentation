# Infrastructure as Code

Ce projet utilise **Terraform** comme unique outil d'Infrastructure as Code pour décrire, provisionner et maintenir l’infrastructure Azure de manière déclarative, modulaire et reproductible.

---

## Objectifs de l'IaC

- Versionner l’infrastructure dans Git (GitOps)
- Garantir la cohérence entre environnements (dev/prod)
- Utiliser un **backend distant** sécurisé (Azure Storage Account)
- Authentifier la CI sans secret via **OIDC**
- Permettre l’ajout facile de composants Helm/Kubernetes

---

## Structure du code Terraform

```text
terraform/
└── prod/                    # Environnement Prod
    ├── aks.tf               # Cluster AKS
    ├── acr.tf               # Azure Container Registry
    ├── data.tf              # Data sources
    ├── dns.tf               # DNS Azure
    ├── helm.tf               # Helm charts
    ├── identity.tf          # Identity: Federation & rôle OIDC
    ├── manifests.tf         # Manifests Kubernetes
    ├── outputs.tf           # Export des variables utiles
    ├── providers.tf         # Configuration des providers (Azure, Kubernetes)
    ├── variables.tf         # Déclaration des variables d'entrée
    └── vault.tf             # Azure Key Vault           
```

> ⚠️ Cette structure est duplicable pour chaque environnement.

---

## Gestion du state

Le `terraform.tfstate` est stocké dans un **Azure Storage Account par environnement** (Cf [Boostrap Azure](./bootstrap.md)).

- 1 Resource Group = 1 Storage Account = 1 environnement (`prod`, `dev`, etc.)
- Conteneur storage nommé `tfstate-<env>`

```hcl
# terraform/prod/backend.tf
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-openmrscore-<env>"
    storage_account_name = "openmrscore<env>sa01"
    container_name       = "tfstate-<env>"
    key                  = "terraform.tfstate"
  }
}
```

---

## Authentification CI/CD avec Azure

L’authentification à Azure depuis GitHub Actions se fait via **OIDC**, sans secrets statiques.

**Configuration dans la CI** :

```yaml
env:
  ARM_USE_OIDC: true
  ARM_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
  ARM_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
  ARM_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
```

**Authentification dans le pipeline** :

```yaml
- name: Configure Azure Credentials
  uses: azure/login@v2
  with:
    client-id: ${{ secrets.AZURE_CLIENT_ID }}
    tenant-id: ${{ secrets.AZURE_TENANT_ID }}
    subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
```

> La fédération OIDC est créée manuellement dans Azure (Cf [Boostrap Azure](./bootstrap.md)).

---

## Bonnes pratiques suivies

- 📂 Un dossier par environnement (`prod/`, `dev/`)
- 🔐 Aucun secret stocké dans le repo (OIDC utilisé)
- 🌱 Tous les composants sont versionnés dans Git
- 🧪 Les `terraform validate` et `terraform fmt` sont exécutés automatiquement via CI

---

## Liens utiles

- [Documentation Terraform](https://developer.hashicorp.com/terraform/docs)
- [Terraform Azure Backend](https://developer.hashicorp.com/terraform/language/backend/azurerm)

---

*Documentation maintenue par l’équipe DevOps – Projet AudioProthèse+*