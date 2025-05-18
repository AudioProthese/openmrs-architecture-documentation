# Objectifs du Projet

## Objectif global

Déployer une architecture automatisée, sécurisée et résiliente, autour d'une application de santé conteneurisée, avec supervision, CI/CD, et documentation complète à destination des équipes internes.

!!! info 
    Notre proposition de solution est basée sur le logiciel Open Source [OpenMRS](https://openmrs.org/fr/), qui est un système de gestion de dossiers médicaux électroniques (DME) conçu pour les soins de santé dans les pays à revenu faible et intermédiaire.

## Objectifs spécifiques

### Automatisation & IaC

- Provisionnement de l’infrastructure via IaC.
- Déploiement GitOps via ArgoCD, avec CI/CD GitLab.

### Conteneurisation

- Conteneurisation d’une application de santé.
- Déploiement sur Kubernetes (avec Helm).
- Sécurisation des images Docker et du registre privé.

### Observabilité

- Intégration de Prometheus + Grafana pour la supervision.
- Centralisation des logs avec Loki.
- Alerting et visualisation temps réel des incidents critiques.

### Résilience

- Mise en place de sauvegardes automatiques (Velero).
- Tests de montée en charge et de résilience.
- Architecture scalable et haute disponibilité (autoscalers, HPA/VPA, node pools).

### Sécurité

- Intégration de mécanismes de chiffrement, gestion de secrets et contrôle d'accès.
- Déploiement de scans de vulnérabilités dans la chaîne CI/CD.

### Collaboration & documentation

- Création d’une documentation technique structurée avec MkDocs.
- Mise en place d’un wiki technique pour le transfert de compétences.
- Procédures d’exploitation, onboarding, et MCO rédigées.

---

## Résultat attendu

La solution finale devra permettre à AudioProthèse+ :

- De **détecter et répondre aux incidents** en temps réel.
- D’assurer la **conformité réglementaire** sur le traitement des données sensibles.
- D’avoir une **infrastructure stable, évolutive et documentée**.
- De disposer d’un **MVP opérationnel** démontrable en soutenance vidéo.

---

*Documentation maintenue par l’équipe DevOps – Projet AudioProthèse+*