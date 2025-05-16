<img height="96" src="./img/logo.jpeg" width="96" align="right"/>

# Home

AudioProthèse+ est un réseau de centres d'audioprothèse implanté dans plusieurs villes en France, offrant des services de diagnostic, d'appareillage et de suivi pour les personnes souffrant de troubles auditifs.

!!! info 
    Notre proposition de solution est basée sur le logiciel Open Source [OpenMRS](https://openmrs.org/fr/), qui est un système de gestion de dossiers médicaux électroniques (DME) conçu pour les soins de santé dans les pays à revenu faible et intermédiaire.

## Contexte

Cette documentation couvre l’ensemble des aspects techniques de la plateforme, notamment :

- L’architecture globale du système
- Les choix technologiques (Kubernetes, microservices, CI/CD, etc.)
- Les composants principaux et leurs interactions
- Les principes de sécurité et de haute disponibilité
- Les stratégies de déploiement et de supervision
- La méthode de déploiement et de mise à jour

## Organisation des dépôts

L'ensemble des configurations sont hébergées au sein de l'organisation :fontawesome-brands-github: GitHub [AudioProthèse+](https://github.com/AudioProthese) et sont organisées de la manière suivante :

- [openmrs-core-infrastructure](https://github.com/AudioProthese/openmrs-core-infrastructure) : Code source de l'infrastructure de base, incluant les configurations Terraform, Kubernetes ainsi que la CI/CD permettant de déployer l'ensemble de l'infrastructure.

- [openmrs-architecture-documentation](https://github.com/AudioProthese/openmrs-architecture-documentation) : Documentation de l'architecture technique de la plateforme AudioProthèse+.

- [openmrs-technical-architecture-document](https://github.com/AudioProthese/openmrs-technical-architecture-document) : Document d'architecture technique de la plateforme AudioProthèse+.

- [openmrs-distro-referenceapplication](https://github.com/AudioProthese/openmrs-technical-architecture-document) : Code source de la distribution OpenMRS Reference Application, incluant le front/back-end de la plateforme AudioProthèse+.

## Diagramme d'architecture globale

## Construire l'infrastructure

Le déploiement et la mise à jour de l'infrastructure sont réalisés à l'aide de Terraform, GitHub Actions et ArgoCD. Les process de création d'infrastructure sont détaillés dans la section [Déploiement](./Déploiement/deploiement.md).

Le détail sur les choix techniques et les outils utilisés pour la mise en place de l'infrastructure sont disponibles dans la section [Outils](./Outils/index.md).