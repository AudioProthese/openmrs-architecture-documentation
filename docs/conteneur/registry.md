# Container Registry

## Azure Container Registry

Les images Docker du projet sont publiées automatiquement dans un registre privé Azure Container Registry (ACR) par environnement :  
`openmrsacr<env>.azurecr.io`

### Publication automatisée

La publication des images est gérée par GitHub Actions :

- À chaque push sur la branche `main`, les workflows CI/CD construisent et poussent les images Docker (`backend`, `frontend`, `gateway`) vers l’ACR.
- L'authentification vers Azure et la registry se fait via `OIDC`
- Les images sont taguées avec `latest` et disponibles pour déploiement.

Voir le workflow : 

[.github/workflows/docker-build-push.yml](https://github.com/AudioProthese/openmrs-distro-referenceapplication/blob/main/.github/workflows/docker-build-push.yml)

### Accès et authentification

Pour accéder à la registry depuis votre poste :

```sh
az acr login --name openmrsacr<env>
```

Ou via Docker :

```sh
docker login openmrsacr<env>.azurecr.io
```

Un accès Azure avec les droits appropriés est requis.

### Déploiement

Pour utiliser les images depuis la registry dans un `docker-compose.yml` :

```yaml
services:
  backend:
    image: openmrsacr<env>.azurecr.io/openmrscore-backend:latest
  frontend:
    image: openmrsacr<env>.azurecr.io/openmrscore-frontend:latest
  gateway:
    image: openmrsacr<env>.azurecr.io/openmrscore-gateway:latest
```

---

*Documentation maintenue par l’équipe DevOps – Projet AudioProthèse+*