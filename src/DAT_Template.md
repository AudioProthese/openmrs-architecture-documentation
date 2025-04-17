---
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

#Add special blocs by awesomebox
header-includes:
- |
  ```{=latex}
  \usepackage{awesomebox}
  ```
pandoc-latex-environment:
  noteblock: [note]
  tipblock: [tip]
  warningblock: [warning]
  cautionblock: [caution]
  importantblock: [important]

#Add figure TOC
lof: true

#Background page
page-background: "img/bg/pages_background.pdf"
---
## Références générales

| Références | DAT                               |
| ---------- | --------------------------------- |
| Type       | Document d'architecture technique |
| Diffusion  | Confidentiel                      |

### Historique du document

| Historique |         |             |                  |
| ---------- | ------- | ----------- | ---------------- |
| Date       | Version | Description | Auteur           |
| 11/01/2023 | 0.1     | Création    | Fabien CHEVALIER |

### Objectif du document

Ce document technique regroupe l’ensemble des informations concernant la **gouvernance de l’infrastructure de Maléo**. Il a pour objectif de spécifier l’ensemble des mécanismes techniques, des logiciels et des matériels qui sont mis en place dans le cadre de la gouvernance.

::: note
L'infrastructure présentée est majoritairement déployée sur le cloud Azure, mais bénéficie d’une interconnexion avec les sites de Paris et Bruxelles permettant le monitoring des équipements réseaux présents sur site.
:::

\newpage

