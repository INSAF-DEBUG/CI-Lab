# 🚀 CI-Lab — Mise en place d'une chaîne CI/CD

> Mise en place d'une chaîne d'intégration continue permettant
> d'automatiser la construction, l'analyse et la publication
> d'une application Java.

---

## 📋 Sommaire

- [1. Présentation](#1--présentation)
- [2. Architecture](#2--architecture)
- [3. Technologies utilisées](#3--technologies-utilisées)
- [4. Infrastructure](#4--infrastructure)
- [5. Structure du projet](#5--structure-du-projet)
- [6. Préparation de l'environnement](#6--préparation-de-lenvironnement)
- [7. Git et GitHub](#7--git-et-github)
- [8. Maven](#8--maven)
- [9. Nexus Repository](#9--nexus-repository)
- [10. Jenkins](#10--jenkins)
- [11. SonarQube et PostgreSQL](#11--sonarqube-et-postgresql)
- [12. Intégration Jenkins / SonarQube](#12--intégration-jenkins--sonarqube)
- [13. Intégration Jenkins / Nexus](#13--intégration-jenkins--nexus)
- [14. Pipeline CI](#14--pipeline-ci)
- [15. Publication de l'artefact](#15--publication-de-lartefact)
- [16. Gestion des erreurs](#16--gestion-des-erreurs)
- [17. Captures d'écran](#17--captures-décran)
- [18. Résultat final](#18--résultat-final)
- [19. Objectifs atteints](#19--objectifs-atteints)
- [20. Conclusion](#20--conclusion)

---

## 1. 📖 Présentation

Ce projet consiste à mettre en place une chaîne d'**intégration continue (CI)** permettant d'automatiser les principales étapes du cycle de développement d'une application Java.

### 🎯 Objectif

L'objectif est de passer automatiquement du **code source** à la **génération et à la publication d'un artefact Maven**.

### 🔄 Flux global

```text
Développeur
     │
     ▼
    Git
     │
     ▼
  GitHub
     │
     ▼
  Jenkins
     │
     ▼
   Maven
     │
     ├──────────────► SonarQube
     │
     ▼
    JAR
     │
     ▼
   Nexus
