#!/bin/bash

# ==========================================
# Installation automatisée de Apache JMeter
# Projet : CI-Lab
# ==========================================

set -e

# Chargement de la configuration
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/jmeter.conf"

echo "=== Installation de Apache JMeter ${JMETER_VERSION} ==="

# Vérification de Java
if ! command -v java >/dev/null 2>&1; then
    echo "ERREUR : Java n'est pas installé."
    exit 1
fi

echo "Java détecté :"
java -version

# Création du compte applicatif s'il n'existe pas
if ! id "${JMETER_USER}" >/dev/null 2>&1; then
    echo "Création du compte ${JMETER_USER}..."

    useradd --system \
            --create-home \
            --home-dir "${JMETER_HOME}" \
            --shell /sbin/nologin \
            "${JMETER_USER}"
fi

# Vérification de l'archive
if [ ! -f "${JMETER_ARCHIVE}" ]; then
    echo "ERREUR : Archive JMeter introuvable : ${JMETER_ARCHIVE}"
    exit 1
fi

# Création du répertoire d'installation
mkdir -p "${JMETER_HOME}"

# Extraction de JMeter
echo "Extraction de JMeter..."

tar -xzf "${JMETER_ARCHIVE}" \
    --strip-components=1 \
    -C "${JMETER_HOME}"

# Création des répertoires de travail
mkdir -p "${JMETER_TESTS}"
mkdir -p "${JMETER_RESULTS}"
mkdir -p "${JMETER_REPORTS}"

# Attribution des permissions
chown -R "${JMETER_USER}:${JMETER_USER}" "${JMETER_HOME}"

# Vérification finale
echo "Vérification de JMeter..."

sudo -u "${JMETER_USER}" \
    "${JMETER_HOME}/bin/jmeter" --version

echo "=== Installation de JMeter terminée ==="
