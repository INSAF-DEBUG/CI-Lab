#!/bin/bash

set -e

source nexus-config.env

JAR_FILE="target/ci-app-1.0-SNAPSHOT.jar"

if [ ! -f "$JAR_FILE" ]; then
    echo "ERREUR : JAR introuvable : $JAR_FILE"
    exit 1
fi

echo "=== Déploiement vers Nexus ==="
echo "Nexus : $NEXUS_URL"
echo "Repository : $NEXUS_REPOSITORY"
echo "Artifact : $JAR_FILE"

curl -f -u "$NEXUS_USER:$NEXUS_PASSWORD" \
    --upload-file "$JAR_FILE" \
    "$NEXUS_URL/repository/$NEXUS_REPOSITORY/insaf/cilab/ci-app/1.0-SNAPSHOT/ci-app-1.0-SNAPSHOT.jar"

echo "=== Déploiement Nexus réussi ==="

