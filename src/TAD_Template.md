---
# Document informations
title: "Document d'Architecture Technique"
author: AudioProthèse+
subject: "Description de l'architecture technique de l'infrastructure hébergeant l'application AudioProthèse+"
date: "17-04-2025"
keywords: [DAT, Gouvernance]

#Headers titles
header-center: "AudioProthèse+"

#Footer titles
footer-center: "SupDeVinci - 2025"

#Add TOC
toc: true
toc-title: "Sommaire"
toc-own-page: true

#Add a title page
titlepage: true,
titlepage-rule-height: 0
titlepage-background: "img/bg/pages_background.pdf"
titlepage-logo: "img/icon.jpeg"

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

# Références générales

| Références | DAT                               |
| ---------- | --------------------------------- |
| Type       | Document d'architecture technique |
| Diffusion  | Confidentiel                      |

## Historique du document

| Historique |         |             |                  |
| ---------- | ------- | ----------- | ---------------- |
| Date       | Version | Description | Auteur           |
| 17/04/2025 | 0.1     | Création    | Fabien CHEVALIER |

## Objectif du document

Ce document technique regroupe l’ensemble des informations concernant la **l'infrastructure hébergeant l'application AudioProthèse+**. Il a pour objectif de spécifier l’ensemble des mécanismes techniques, des logiciels et des matériels qui sont mis en place dans le cadre de la livraison de la plateforme.

::: note
L'infrastructure présentée est la version 1.0 de l'architecture technique de l'application AudioProthèse+.
:::

\newpage
