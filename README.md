# Dossier Architecture Technique

<img src="https://raw.githubusercontent.com/AudioProthese/.github/refs/heads/main/profile/icon.jpeg" align="right" height="110"/>

![LaTeX Version](https://img.shields.io/badge/latex-v2014-008080?logo=latex)
![pandoc Version](https://img.shields.io/badge/pandoc-3.6.4-0266CC?logo=pandoc)

- [Dossier Architecture Technique](#dossier-architecture-technique)
  - [Description](#description)
  - [Prérequis](#prérequis)
  - [Génération du document](#génération-du-document)
  - [Edition du contenu](#edition-du-contenu)


## Description

Ce dépôt contient le modèle de document d'architecture technique (TAD) pour l'application AudioProthèse+. Ce modèle est conçu pour être utilisé avec `pandoc` et `LaTeX`, et il est basé sur le format Markdown.

Éditer le fichier `src/TAD_Template.md` pour changer le contenu du document. Au commit, la CI/CD se charge de générer le document au format PDF et est récupérable 

## Prérequis

Pour générer ce document localement, vous devez avoir installé les outils suivants :

- [pandoc](https://pandoc.org/installing.html) (version 3.0 ou supérieure)
- [LaTeX](https://www.latex-project.org/get/) (distribution TeX Live ou MikTeX recommandée)
- [pandoc-latex-environment](https://pandoc-latex-environment.readthedocs.io/en/latest/)

L'ensemble est installable via `brew` : 

```bash
brew install pandoc
brew install mactex
# pipx to install pandoc-latex-environment
pipx install pandoc-latex-environment
```

## Génération du document

```bash
chmod +x build.sh && ./build.sh
```

## Edition du contenu

Modifier le fichier `src/TAD_Template.md` pour changer le contenu du document. En début de document, vous trouverez les métadonnées du document. Vous pouvez les modifier pour changer le titre, le nom de l'auteur, la date, etc.

Le contenu du document est éditable en `Markdown`, à la suite de la configuration. Vous pouvez utiliser les balises Markdown habituelles pour formater le texte, ajouter des images, des tableaux, etc.