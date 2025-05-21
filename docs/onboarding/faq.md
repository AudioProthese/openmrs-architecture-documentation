# FAQ interne

## Quel est le périmètre de la mission DevOps ?

Le périmètre couvre :

- La mise en place d'une infrastructure Cloud Azure managée via Terraform
- Le déploiement et l’automatisation d’un cluster AKS avec CI/CD
- L'intégration d'une solution de supervision complète (Prometheus, Grafana, Alertmanager)
- La sécurité des secrets via Azure Key Vault + External Secrets Operator
- L'intégration de l’application OpenMRS en environnement Dev et Prod

---

## Quels environnements sont gérés ?

Deux environnements sont définis :

- **dev** : pour les tests, développements et itérations fréquentes
- **prod** : pour les mises en production validées et stables

Chaque environnement possède :

- Son propre backend Terraform (Storage Account isolé)
- Son propre cluster AKS
- Des secrets, rôles et configurations spécifiques

---

## Où sont stockés les secrets ?

Les secrets sont stockés de manière sécurisée dans **Azure Key Vault**.  
Ils sont synchronisés dans Kubernetes à l'aide d’**External Secrets Operator**, ce qui évite tout stockage dans Git ou dans les manifests.

Actuellement, cela est utilisé dans le namespace `authgate`, mais l'architecture permet de l’étendre à tous les namespaces.

---

## Comment se fait l’authentification depuis la CI/CD vers Azure ?

Nous utilisons **OIDC (Workload Identity Federation)** avec GitHub Actions.  
Cela évite de stocker des secrets dans les workflows et repose sur des identités managées sécurisées.

---

## Où sont stockés les états Terraform ?

Les fichiers `terraform.tfstate` sont stockés dans des **Azure Storage Accounts**, un par environnement :

- Container `tfstate-dev` pour dev
- Container `tfstate-prod` pour prod

Ces containers doivent être initialisés manuellement une fois au bootstrap.

---

## Comment consulter les dashboards et alertes ?

Les dashboards Grafana sont disponibles sur l'URL publique du cluster, exposés via Ingress avec certificat TLS.  
Les alertes sont gérées par Alertmanager, et envoyées vers Telegram.

---

## Comment contribuer ou modifier l'infrastructure ?

Les modifications doivent être faites via :

- Des branches Git suivies de Pull Requests
- L’exécution des pipelines GitHub Actions (lint, plan, apply)
- Respect des bonnes pratiques de versioning et de validation manuelle avant `terraform apply`

---

## Quels sont les outils utilisés dans le projet ?

- **Terraform** : Provisionnement de l’infrastructure Azure
- **Helm** : Déploiement des composants Kubernetes
- **Trivy** : Scan de vulnérabilités des images Docker
- **Prometheus / Grafana / Alertmanager** : Supervision
- **Azure Key Vault + ESO** : Gestion des secrets
- **GitHub Actions** : CI/CD avec OIDC Azure

---

## À qui s’adresser en cas de question technique ?

Tu peux contacter l'ingénieur DevOps référent du projet via Teams ou Slack, ou consulter la [page Contacts](../annexes/contacts.md) pour les informations à jour.

---

*Documentation maintenue par l’équipe DevOps – Projet AudioProthèse+*
