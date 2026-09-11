# CI-Lab — Mise en place d'une chaîne CI/CD

Mise en place d'une chaîne d'intégration continue pour automatiser la construction, l'analyse et la publication d'une application Java.

---

## 📋 Sommaire

1. [Présentation](#1-présentation)
2. [Architecture](#2-architecture)
3. [Technologies utilisées](#3-technologies-utilisées)
4. [Infrastructure](#4-infrastructure)
5. [Structure du projet](#5-structure-du-projet)
6. [Préparation de l'environnement](#6-préparation-de-lenvironnement)
7. [Git et GitHub](#7-git-et-github)
8. [Maven](#8-maven)
9. [Nexus Repository](#9-nexus-repository)
10. [Configuration Maven / Nexus](#10-configuration-maven--nexus)
11. [Jenkins](#11-jenkins)
12. [SonarQube et PostgreSQL](#12-sonarqube-et-postgresql)
13. [Intégration Jenkins / SonarQube](#13-intégration-jenkins--sonarqube)
14. [Intégration Jenkins / Nexus](#14-intégration-jenkins--nexus)
15. [Pipeline CI](#15-pipeline-ci)
16. [Publication de l'artefact](#16-publication-de-lartefact)
17. [Gestion des erreurs](#17-gestion-des-erreurs)
18. [Captures d'écran](#18-captures-décran)
19. [Résultat final](#19-résultat-final)
20. [Objectifs atteints](#20-objectifs-atteints)
21. [Conclusion](#21-conclusion)

---

# 1. Présentation

Ce projet consiste à mettre en place une chaîne d'intégration continue permettant d'automatiser les principales étapes du cycle de développement d'une application Java.

L'objectif du laboratoire est de mettre en œuvre une chaîne complète permettant de passer du développement du code source à la génération et à la publication d'un artefact Maven.

### Chaîne globale

```text
Développement
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
