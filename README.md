# CI-Lab — Mise en place d'une chaîne CI/CD

Mise en place d'une chaîne d'intégration continue pour automatiser la construction, l'analyse et la publication d'une application Java.

---

## 📋 Sommaire

1. Présentation
2. Architecture
3. Technologies utilisées
4. Infrastructure
5. Structure du projet
6. Préparation de l'environnement
7. Git et GitHub
8. Maven
9. Nexus Repository
10. Configuration Maven / Nexus
11. Jenkins
12. SonarQube et PostgreSQL
13. Intégration Jenkins / SonarQube
14. Intégration Jenkins / Nexus
15. Pipeline CI
16. Publication de l'artefact
17. Gestion des erreurs
18. Captures d'écran
19. Résultat final
20. Objectifs atteints
21. Conclusion

---

# 1. Présentation

Ce projet consiste à mettre en place une chaîne d'intégration continue permettant d'automatiser les principales étapes du cycle de développement d'une application Java.

L'objectif du laboratoire est de mettre en œuvre une chaîne complète permettant de passer du développement du code source à la génération et à la publication d'un artefact Maven.

## Chaîne globale

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

Cette chaîne permet notamment d'automatiser :

- la récupération du code source ;
- la compilation ;
- l'exécution des tests ;
- l'analyse de la qualité du code ;
- la génération du fichier JAR ;
- la publication de l'artefact dans Nexus Repository.

---

# 2. Architecture

## 2.1 Architecture globale

L'architecture du laboratoire repose sur plusieurs machines virtuelles ayant chacune un rôle précis.

    ┌─────────────────┐
    │   Développeur   │
    └────────┬────────┘
             │
             ▼
    ┌─────────────────┐
    │      Git        │
    └────────┬────────┘
             │
             ▼
    ┌─────────────────┐
    │     GitHub      │
    └────────┬────────┘
             │
             ▼
    ┌─────────────────┐
    │     Jenkins     │
    │ 192.168.42.151  │
    └────────┬────────┘
             │
    ┌────────┴────────────┐
    │                     │
    ▼                     ▼
┌──────────────┐    ┌──────────────┐
│  SonarQube   │    │     Nexus    │
│192.168.42.152│    │192.168.42.128│
└──────┬───────┘    └──────────────┘
       │
       ▼
┌──────────────┐
│  PostgreSQL  │
└──────────────┘

### Fichiers d'architecture

Le schéma Draw.io est disponible dans :

    architecture/
    ├── 01-global-architecture.drawio
    └── 01-global-architecture.png

---

# 3. Technologies utilisées

| Technologie | Rôle |
|---|---|
| Git | Versionnement du code source |
| GitHub | Hébergement du dépôt distant |
| Java | Environnement de développement et de compilation |
| Maven | Compilation, tests, packaging et déploiement |
| Jenkins | Automatisation du processus CI |
| SonarQube | Analyse statique et qualité du code |
| PostgreSQL | Base de données utilisée par SonarQube |
| Nexus Repository | Gestion et stockage des artefacts Maven |
| Ubuntu Server | Hébergement de Jenkins, SonarQube et Nexus |
| CentOS 7 | Environnement de développement |

---

# 4. Infrastructure

## 4.1 Machines virtuelles

| Machine | Système | Adresse IP | Rôle |
|---|---|---|---|
| CentOS | CentOS 7 | 192.168.42.157 | Développement, Git et Maven |
| Jenkins | Ubuntu Server 22.04.5 | 192.168.42.151 | Jenkins, Maven et Git |
| SonarQube | Ubuntu Server 22.04.5 | 192.168.42.152 | SonarQube et PostgreSQL |
| Nexus | Ubuntu Server 22.04.5 | 192.168.42.128 | Nexus Repository |

Les machines communiquent sur le réseau :

    192.168.42.0/24

## 4.2 CentOS

La machine CentOS constitue l'environnement de développement.

Elle permet notamment de :

- préparer le projet Java ;
- installer Java et Maven ;
- configurer Git ;
- construire le projet ;
- générer le JAR ;
- publier le code sur GitHub.

Adresse IP :

    192.168.42.157

## 4.3 Jenkins

Jenkins est installé sur une machine Ubuntu Server.

Adresse IP :

    192.168.42.151

Les principaux outils utilisés par Jenkins sont :

- Java 21 ;
- Maven ;
- Git.

## 4.4 SonarQube

SonarQube est installé sur une machine Ubuntu Server.

Adresse IP :

    192.168.42.152

SonarQube utilise PostgreSQL pour stocker ses données.

Le service Web utilise le port :

    9000

## 4.5 Nexus

Nexus Repository est installé sur une machine Ubuntu Server dédiée.

Adresse IP :

    192.168.42.128

L'interface Web de Nexus utilise le port :

    8081

Nexus est utilisé pour stocker les artefacts Maven générés par le pipeline.

---

# 5. Structure du projet

La structure principale du dépôt est la suivante :

    CI-Lab/
    │
    ├── architecture/
    │   ├── 01-global-architecture.drawio
    │   └── 01-global-architecture.png
    │
    ├── screenshots/
    │   └── .gitkeep
    │
    └── README.md

Le dossier `screenshots/` contient les captures documentant les différentes étapes du laboratoire.

---

# 6. Préparation de l'environnement

## 6.1 CentOS

La première étape consiste à préparer la machine CentOS.

Les éléments suivants sont vérifiés :

- version du système ;
- nom d'hôte ;
- adresse IP ;
- connectivité réseau ;
- DNS ;
- ressources système ;
- configuration de sudo.

Le système est ensuite mis à jour.

## 6.2 Java

Java est nécessaire pour la construction du projet Maven.

La version installée peut être vérifiée avec :

    java -version

## 6.3 Maven

Maven est utilisé pour automatiser la construction du projet Java.

Vérification :

    mvn -version

## 6.4 Git

Git est utilisé pour versionner le projet.

Vérification :

    git --version

La configuration de Git est effectuée avant la création du dépôt.

---

# 7. Git et GitHub

## 7.1 Initialisation du dépôt

Le projet est initialisé avec Git :

    git init

L'état du dépôt est vérifié avec :

    git status

## 7.2 Configuration du dépôt distant

Le dépôt GitHub est ajouté comme dépôt distant.

Vérification :

    git remote -v

## 7.3 Premier commit

Les fichiers du projet sont ajoutés au suivi Git :

    git add .

Puis un commit est créé :

    git commit -m "Initial commit"

## 7.4 Publication

Le projet est ensuite publié sur GitHub :

    git push

Le dépôt GitHub devient ainsi la source utilisée par Jenkins.

---

# 8. Maven

## 8.1 Création du projet

Le projet Java utilise une structure Maven standard :

    project/
    ├── pom.xml
    └── src/
        ├── main/
        │   └── java/
        └── test/
            └── java/

Le fichier principal de configuration est :

    pom.xml

## 8.2 Compilation

La compilation est réalisée avec :

    mvn compile

Les classes compilées sont générées dans :

    target/

## 8.3 Tests

Les tests unitaires sont exécutés avec :

    mvn test

## 8.4 Packaging

La génération de l'artefact est réalisée avec :

    mvn package

Le fichier JAR est généré dans :

    target/

## 8.5 Déploiement

Lorsque la configuration Nexus est terminée, Maven peut publier l'artefact avec :

    mvn deploy

---

# 9. Nexus Repository

## 9.1 Rôle

Nexus Repository joue le rôle de gestionnaire d'artefacts.

Il reçoit et stocke les fichiers JAR produits par Maven.

    Maven
      │
      ▼
     JAR
      │
      ▼
    Nexus Repository
      │
      ▼
    Maven Snapshots

## 9.2 Installation

L'installation comprend :

- vérification de Java ;
- téléchargement de Nexus ;
- extraction de l'archive ;
- création de l'utilisateur Nexus ;
- configuration des permissions ;
- configuration du service ;
- démarrage du service.

Une erreur 404 a été rencontrée lors d'une première tentative de téléchargement. L'archive correcte a ensuite été utilisée.

## 9.3 Service

Le service Nexus est vérifié après son installation.

Le port utilisé est :

    8081

## 9.4 Repository Maven Snapshots

Un repository Maven Snapshots est configuré afin de recevoir les artefacts produits pendant le développement.

---

# 10. Configuration Maven / Nexus

## 10.1 settings.xml

Maven utilise un fichier `settings.xml` pour définir les paramètres nécessaires à la communication avec Nexus.

La configuration comprend notamment les informations d'authentification.

## 10.2 distributionManagement

Le fichier `pom.xml` contient la configuration permettant d'indiquer à Maven le repository de destination.

Principe :

    <distributionManagement>
        <snapshotRepository>
            <id>...</id>
            <url>...</url>
        </snapshotRepository>
    </distributionManagement>

Les valeurs utilisées correspondent au repository Nexus configuré dans le laboratoire.

## 10.3 Déploiement

Une fois Maven correctement configuré :

    mvn deploy

permet de publier l'artefact dans Nexus.

La présence du JAR dans le repository Maven Snapshots confirme le bon fonctionnement du déploiement.

---

# 11. Jenkins

## 11.1 Installation

Jenkins est installé sur Ubuntu Server.

Une difficulté a été rencontrée lors du démarrage initial du service.

L'analyse des logs a permis d'identifier un problème lié à Java.

Java 21 a ensuite été installé et configuré.

## 11.2 Vérification du service

Le statut de Jenkins peut être vérifié avec :

    systemctl status jenkins

Le service doit être actif.

## 11.3 Configuration initiale

La configuration initiale comprend :

- récupération du mot de passe initial ;
- accès à l'interface Web ;
- installation des plugins suggérés ;
- création du compte administrateur ;
- configuration de l'URL Jenkins.

## 11.4 Outils Jenkins

La machine Jenkins doit disposer de :

- Java 21 ;
- Maven ;
- Git.

Les versions sont vérifiées avec :

    java -version
    mvn -version
    git --version

## 11.5 Répertoire de travail

Le répertoire de travail Jenkins est vérifié afin de garantir que l'utilisateur Jenkins dispose des permissions nécessaires pour exécuter les scripts et construire le projet.

---

# 12. SonarQube et PostgreSQL

## 12.1 Rôle de SonarQube

SonarQube permet d'analyser automatiquement le code source afin d'identifier les problèmes de qualité du projet.

Il est intégré au pipeline Jenkins.

## 12.2 Installation

SonarQube est installé sur :

    192.168.42.152

Le service Web utilise le port :

    9000

## 12.3 Paramètres système

Le paramètre système suivant est configuré :

    vm.max_map_count

Un utilisateur système dédié à SonarQube est également créé.

## 12.4 PostgreSQL

PostgreSQL est utilisé comme base de données pour SonarQube.

Une base dédiée et un utilisateur PostgreSQL sont configurés.

Le principe est :

    SonarQube
        │
        ▼
    PostgreSQL
        │
        ▼
    Base SonarQube

La connexion à la base est ensuite vérifiée.

## 12.5 Service SonarQube

Un service systemd est créé pour gérer SonarQube.

L'activation automatique au démarrage est configurée.

---

# 13. Intégration Jenkins / SonarQube

Jenkins est configuré pour communiquer avec SonarQube.

Les étapes principales sont :

- installation du plugin SonarQube ;
- création d'un token SonarQube ;
- ajout du token dans les credentials Jenkins ;
- configuration du serveur SonarQube ;
- intégration de l'analyse dans le pipeline.

Le flux devient :

    Jenkins
       │
       ▼
     Maven
       │
       ▼
    SonarQube
       │
       ▼
    Analyse du code

Cette intégration permet d'automatiser l'analyse de la qualité du projet pendant le processus CI.

---

# 14. Intégration Jenkins / Nexus

Jenkins est configuré pour publier automatiquement les artefacts Maven dans Nexus.

Les principales étapes sont :

- vérification du service Nexus ;
- configuration des credentials Nexus dans Jenkins ;
- configuration du repository Maven Snapshots ;
- ajout du script de déploiement ;
- vérification de la connexion Jenkins / Nexus ;
- publication du JAR.

Flux :

    Jenkins
       │
       ▼
     Maven
       │
       ▼
     Package
       │
       ▼
       JAR
       │
       ▼
      Nexus

---

# 15. Pipeline CI

Le pipeline CI permet d'automatiser l'ensemble des opérations.

Le flux global est :

    ┌───────────────┐
    │    GitHub     │
    └───────┬───────┘
            │
            ▼
    ┌───────────────┐
    │    Jenkins    │
    └───────┬───────┘
            │
            ▼
    ┌───────────────┐
    │     Maven     │
    ├───────────────┤
    │    Compile    │
    │     Test      │
    │    Analyse    │
    │    Package    │
    └───────┬───────┘
            │
            ├──────────────► SonarQube
            │
            ▼
    ┌───────────────┐
    │      JAR      │
    └───────┬───────┘
            │
            ▼
    ┌───────────────┐
    │     Nexus     │
    │    Snapshots  │
    └───────────────┘

## Étapes du pipeline

### Étape 1 — Checkout

Jenkins récupère le projet depuis GitHub.

### Étape 2 — Compilation

Maven compile les sources Java :

    mvn compile

### Étape 3 — Tests

Les tests unitaires sont exécutés :

    mvn test

### Étape 4 — Analyse

Le projet est analysé par SonarQube.

### Étape 5 — Packaging

Maven génère le fichier JAR :

    mvn package

### Étape 6 — Publication

L'artefact est publié dans Nexus :

    mvn deploy

---

# 16. Publication de l'artefact

La publication constitue la dernière étape du pipeline.

Le résultat attendu est :

    Code source
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
         ▼
        JAR
         │
         ▼
       Nexus

La présence du fichier JAR dans le repository Maven Snapshots confirme le bon fonctionnement de la chaîne.

---

# 17. Gestion des erreurs

Le laboratoire a permis d'identifier et de résoudre plusieurs problèmes.

## 17.1 Téléchargement de Nexus

Une première tentative de téléchargement de Nexus a généré une erreur HTTP 404.

Après vérification, l'archive correcte a été téléchargée puis extraite.

## 17.2 Démarrage de Jenkins

Jenkins ne démarrait pas correctement lors de la première tentative.

L'analyse des journaux a permis d'identifier un problème lié à Java.

L'installation de Java 21 a permis de résoudre le problème.

## 17.3 Téléchargement de SonarQube

Plusieurs problèmes ont été rencontrés pendant le téléchargement de SonarQube :

- téléchargement interrompu ;
- archive incomplète ;
- archive corrompue ;
- extraction incomplète ;
- vérification de l'espace disque.

La procédure de résolution a consisté à supprimer l'archive incorrecte, vérifier les ressources disponibles, reprendre le téléchargement puis effectuer une nouvelle extraction.

---

# 18. Captures d'écran

Les différentes étapes du laboratoire sont documentées par des captures d'écran.

Elles couvrent notamment :

- préparation de CentOS ;
- installation de Java ;
- installation de Maven ;
- configuration de Git ;
- création du projet Maven ;
- compilation ;
- tests ;
- packaging ;
- installation de Nexus ;
- configuration Maven / Nexus ;
- création de la VM Jenkins ;
- installation de Jenkins ;
- configuration de SonarQube ;
- configuration de PostgreSQL ;
- intégration Jenkins / SonarQube ;
- intégration Jenkins / Nexus ;
- exécution du pipeline ;
- publication du JAR.

Les captures sont regroupées dans :

    screenshots/

---

# 19. Résultat final

La chaîne finale obtenue est :

    ┌──────────────┐
    │ Développeur  │
    └──────┬───────┘
           │
           ▼
    ┌──────────────┐
    │     Git      │
    └──────┬───────┘
           │
           ▼
    ┌──────────────┐
    │    GitHub    │
    └──────┬───────┘
           │
           ▼
    ┌──────────────┐
    │   Jenkins    │
    └──────┬───────┘
           │
           ▼
    ┌──────────────┐
    │    Maven     │
    └──────┬───────┘
           │
      ┌────┴────┐
      │         │
      ▼         ▼
┌──────────┐ ┌──────────┐
│SonarQube │ │   JAR    │
└──────────┘ └────┬─────┘
                  │
                  ▼
           ┌──────────────┐
           │    Nexus     │
           └──────────────┘

Le processus automatisé est donc :

    Modification du code
            ↓
          Commit
            ↓
          GitHub
            ↓
         Jenkins
            ↓
          Maven
            ↓
         Analyse
            ↓
         Package
            ↓
           JAR
            ↓
          Nexus

---

# 20. Objectifs atteints

- [x] Préparer l'environnement CentOS.
- [x] Installer et vérifier Java.
- [x] Installer et configurer Maven.
- [x] Installer et configurer Git.
- [x] Créer le projet Maven.
- [x] Versionner le projet avec Git.
- [x] Publier le projet sur GitHub.
- [x] Installer Jenkins.
- [x] Configurer Java 21 pour Jenkins.
- [x] Configurer Maven et Git sur Jenkins.
- [x] Automatiser le build.
- [x] Installer SonarQube.
- [x] Configurer PostgreSQL.
- [x] Intégrer SonarQube avec Jenkins.
- [x] Installer Nexus Repository.
- [x] Configurer Maven avec Nexus.
- [x] Intégrer Nexus avec Jenkins.
- [x] Générer l'artefact JAR.
- [x] Publier l'artefact dans Nexus.

---

# 21. Conclusion

Ce laboratoire a permis de mettre en œuvre une chaîne d'intégration continue complète autour d'une application Java.

Git et GitHub assurent le versionnement et l'hébergement du code source.

Maven permet de compiler le projet, d'exécuter les tests et de générer l'artefact JAR.

Jenkins automatise l'ensemble des étapes du processus CI.

SonarQube intervient pour analyser la qualité du code source.

PostgreSQL fournit la base de données nécessaire au fonctionnement de SonarQube.

Enfin, Nexus Repository permet de centraliser et de stocker les artefacts Maven générés.

La chaîne finale est donc :

    Développement
          ↓
         Git
          ↓
       GitHub
          ↓
       Jenkins
          ↓
        Maven
          ↓
      SonarQube
          ↓
         JAR
          ↓
        Nexus

Le laboratoire permet ainsi de comprendre concrètement le fonctionnement d'une chaîne CI, depuis la gestion du code source jusqu'à la publication automatisée d'un artefact.
