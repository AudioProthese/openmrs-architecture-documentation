# Provisioning Terraform

Cette page décrit en détail le provisionnement de l'infrastructure Azure via Terraform pour le projet AudioProthèse+.

Chaque composant est déployé de manière déclarative, avec des permissions explicites et une organisation modulaire, en accord avec les bonnes pratiques de production.

---

## Vue d’ensemble du provisioning

Le code Terraform provisionne l’ensemble des briques suivantes :

| Composant                | Description                                                      |
| ------------------------ | ---------------------------------------------------------------- |
| **AKS**                  | Cluster Kubernetes managé avec Workload Identity et OIDC         |
| **ACR**                  | Azure Container Registry connecté à AKS                          |
| **Azure Key Vault**      | Pour la gestion des secrets (RBAC activé)                        |
| **Azure DNS**            | Zone publique utilisée pour le routage et les certificats        |
| **OIDC Federation**      | Fédère un SA Kubernetes avec Azure AD                            |
| **Helm Charts**          | Déploiement de ArgoCD.                                           |
| **Manifests Kubernetes** | ClusterIssuer, Ingress, ESO CRD. injectés via `kubectl_manifest` |

---

## Cluster AKS

Le cluster est déployé avec :

- **Managed Identity** activée (SystemAssigned)
- **OIDC + Workload Identity** (`oidc_issuer_enabled = true`)
- **Web App Routing** intégré avec liaison à la zone DNS
- Un **pools de nœuds default** (2 nœuds, D2_v2)

```hcl
resource "azurerm_kubernetes_cluster" "aks" {
  ...
  workload_identity_enabled = true
  oidc_issuer_enabled       = true
  web_app_routing {
    dns_zone_ids = [azurerm_dns_zone.audioprothese_ovh.id]
  }
}
```

---

## Azure Container Registry (ACR)

Le registre ACR est privé et configuré avec :

- **Rôle `AcrPull` assigné au kubelet identity** du cluster

```hcl
resource "azurerm_role_assignment" "acr_pull" {
  principal_id = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
}
```

---

## Azure Key Vault

Le Key Vault est créé avec :

- **RBAC activé**
- **Soft delete** actif (7 jours)
- Rôle `Key Vault Secrets User` assigné au kubelet AKS

```hcl
enable_rbac_authorization = true
purge_protection_enabled  = false
```

---

## Azure DNS

La zone DNS publique `audioprothese.ovh` est gérée dans Azure et permet :

- Le routage via Web App Routing (AKS)
- Les défis DNS-01 (cert-manager)

Deux rôles `DNS Zone Contributor` sont assignés :

- Kubelet Identity (ExternalDNS)
- WebAppRouting Identity (ingress cert-manager)

---

## Fédérations OIDC (Workload Identity)

Un SA Kubernetes (`workload-identity-sa`) est fédéré avec Azure AD :

```hcl
resource "azurerm_federated_identity_credential" "ESOFederatedIdentity" {
  issuer  = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  subject = "system:serviceaccount:default:workload-identity-sa"
}
```

Cela permet à des pods d’assumer un rôle Azure via OIDC sans secrets.

---

## Déploiements Helm & Manifests

Les composants suivants sont déployés avec `helm_release` et `kubectl_manifest` :

| Composant    | Type     | Description                  |
| ------------ | -------- | ---------------------------- |
| ArgoCD       | Helm     | Helm chart ArgoCD            |
| OpenMRS      | Manifest | Ingress OpenMRS              |
| ESO          | Manifest | CRD External Secret Operator |
| cert-manager | Manifest | CRD cert-manager             |

---

## Configuration Terraform & Providers

### Version & providers requis

Le projet est verrouillé sur des versions spécifiques de Terraform et de ses providers pour garantir une reproductibilité et une stabilité maximales dans le pipeline CI/CD.

```hcl
terraform {
  required_version = "=1.11.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.27.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.19.0"
    }
    ovh = {
      source  = "ovh/ovh"
      version = "2.2.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-openmrscore-prod"
    storage_account_name = "openmrscoreprodsa01"
    container_name       = "tfstate-prod"
    key                  = "terraform.tfstate"
  }
}
```

> ⚠️ Le backend est propre à chaque environnement. Il est configuré manuellement dans Azure (Cf [Boostrap Azure](./bootstrap.md)).

---

### Providers configurés

| Provider  | Usage principal                                                       |
| --------- | --------------------------------------------------------------------- |
| `azurerm` | Provisionnement des ressources Azure (AKS, ACR, DNS, Key Vault, etc.) |
| `helm`    | Déploiement des charts Helm sur le cluster AKS (ArgoCD)               |
| `kubectl` | Application de manifestes Kubernetes (ClusterIssuer, Ingress, etc.)   |

#### Provider Azure

```hcl
provider "azurerm" {
  features {}
}
```

#### Provider Helm

Connexion directe au cluster via les credentials générés par AKS :

```hcl
provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  }
}
```

#### Provider Kubectl

Utilisé pour appliquer des manifestes YAML (non Helm) comme les `ClusterIssuer`, `Ingress`, etc.

```hcl
provider "kubectl" {
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  load_config_file       = false
}
```

---

## Paramétrage via variables

Les fichiers `variables.tf` permettent de configurer dynamiquement l’environnement :

```hcl
variable "env" {
  default = "prod"
}

variable "dns_zone_name" {
  default = "audioprothese.ovh"
}
```

---

## Bonnes pratiques appliquées

- Tous les composants utilisent **RBAC** et identités managées
- Les accès sont **précis et limités** (least privileges)
- La **séparation des environnements** est stricte (`prod`, `dev`, etc.)
- L'utilisation de `depends_on` assure l’ordre correct de création

---

## Liens utiles

- [Terraform Provider Helm](https://registry.terraform.io/providers/hashicorp/helm/latest/docs)
- [Terraform Provider Azurerm](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
- [Terraform Provider Kubectl](https://registry.terraform.io/providers/gavinbunney/kubectl/latest)

---

*Documentation maintenue par l’équipe DevOps – Projet AudioProthèse+*
