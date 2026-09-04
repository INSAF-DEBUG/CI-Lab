#!/bin/bash

set -e

# Fichier de configuration
CONFIG_FILE="./build.conf"

# Vérification de l'existence du fichier de configuration
if [ ! -f "$CONFIG_FILE" ]; then
    echo "ERREUR : fichier de configuration introuvable : $CONFIG_FILE"
    exit 1
fi

# Chargement de la configuration
source "$CONFIG_FILE"

echo "======================================"
echo "       CI-Lab - Build Application"
echo "======================================"

echo "Application : $APP_NAME"
echo "Version     : $APP_VERSION"
echo "======================================"

# Nettoyage, compilation, tests et packaging
echo "[1/1] Clean, compilation, tests et packaging..."
$MAVEN_CMD clean package

echo "======================================"
echo "       BUILD TERMINE AVEC SUCCES"
echo "======================================"

echo "Artefact généré :"
ls -lh "$TARGET_DIR/$ARTIFACT_NAME"


