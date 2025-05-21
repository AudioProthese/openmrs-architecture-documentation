# Pipelines CI/CD

## Build et publication des images Docker

Le pipeline CI/CD du dépôt [openmrs-distro-referenceapplication](https://github.com/AudioProthese/openmrs-distro-referenceapplication) automatise la construction, l’analyse de sécurité et la publication des images Docker dans Azure Container Registry (ACR).

### Fonctionnement du pipeline

- **Déclenchement** : à chaque push sur la branche `main` ou manuellement via GitHub Actions.
- **Authentification** : connexion sécurisée à Azure via OIDC et secrets GitHub.
- **Étapes principales** :
  - **Build** des images Docker pour :
    - le backend (`openmrscore-backend`)
    - le frontend (`openmrscore-frontend`)
    - la gateway (`openmrscore-gateway`)
  - **Scan de sécurité** : chaque image est analysée avec Trivy, et un rapport HTML est généré.
  - **Push** : les images sont poussées dans le registre privé ACR `openmrsacrdev.azurecr.io` avec le tag `latest`.
  - **Artifacts** : les rapports de scan sont archivés dans les artefacts du workflow.

### Exemple de workflow

Voir le fichier :  
[.github/workflows/docker-build-push.yml](https://github.com/AudioProthese/openmrs-distro-referenceapplication/blob/main/.github/workflows/docker-build-push.yml)

### Extrait des jobs principaux

```yaml
jobs:
  build-root:
    steps:
      - docker buildx build --push --tag $ACR_NAME/openmrscore-backend:latest -f Dockerfile .
      - trivy-action ... # scan de sécurité
  build-frontend:
    steps:
      - docker buildx build --push --tag $ACR_NAME/openmrscore-frontend:latest -f frontend/Dockerfile ./frontend
      - trivy-action ...
  build-gateway:
    steps:
      - docker buildx build --push --tag $ACR_NAME/openmrscore-gateway:latest -f gateway/Dockerfile ./gateway
      - trivy-action ...
```

---

*Documentation maintenue par l’équipe DevOps – Projet AudioProthèse+*