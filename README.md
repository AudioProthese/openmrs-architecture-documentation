# Dossier Architecture Technique

<img src="icon.png" align="right" height="110"/>

*Based on [https://github.com/Wandmalfarbe/pandoc-latex-template](Eisvogel) project*

- [Dossier Architecture Technique](#dossier-architecture-technique)
  - [MacOS](#macos)
  - [Windows](#windows)
  - [Comment utiliser le template](#comment-utiliser-le-template)
    - [Makdown](#makdown)
    - [Lancer un export du document](#lancer-un-export-du-document)

## MacOS

```bash
#Install dependencies
brew install --cask mactex
brew install pip
pip install pandoc-latex-environment

# update tlmgr and packages
sudo tlmgr update --self

#MD -> .pdf
./build.sh
```

## Windows

- Télécharger et installer Pandoc : <https://github.com/jgm/pandoc/releases/download/2.19.2/pandoc-2.19.2-windows-x86_64.msi>
- Télécharger et installer Python : <https://www.python.org/>
- Télécharger et installer MikTeX : <https://miktex.org/download>

Puis :

```powershell
pip install pandoc-latex-environment
```

## Comment utiliser le template

Cloner le repo:

```bash
git-clone https://github.com/fabienchevalier/maleo-dat.git
```

### Makdown

Le fichier à modifier ce situe dans `src/DAT_Template.md`. En haut du document, il y a des paramètres à modifier (entre les `---`):

```yaml
# Document informations
title: "Document d'Architecture Technique"
author: [Prénom NOM]
subject: "MISSION"
date: "09-01-2023"
keywords: [DAT, Gouvernance]

#Headers titles
header-center: "Gouvernance"

#Footer titles
footer-center: "Projet Professionnel"

#Add TOC
toc: true
toc-title: "Sommaire"
toc-own-page: true

#Add a title page
titlepage: true,
titlepage-rule-height: 0
titlepage-background: "img/bg/pages_background.pdf"
titlepage-logo: "img/logo_infratech.png"
```

Pour afficher des petites infobulles dans le document, voir [https://github.com/Wandmalfarbe/pandoc-latex-template/raw/master/examples/boxes-with-pandoc-latex-environment-and-awesomebox/document.pdf](=>ici<=)

### Lancer un export du document

MacOS/Linux:

```bash
chmod+x build.sh && ./build.sh
```

Windows:

```powershell
./build.ps1
```

Le PDF sera situé dans le dossier `output/`
