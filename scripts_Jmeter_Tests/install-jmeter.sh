
#!/bin/bash

# ==========================================
# Installation automatisée de Apache JMeter
# Projet : CI-Lab
# ==========================================

set -euo pipefail

# ==========================================
# Chargement de la configuration
# ==========================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -f "${SCRIPT_DIR}/jmeter.conf" ]; then
    echo "ERREUR : jmeter.conf introuvable."
    exit 1
fi

source "${SCRIPT_DIR}/jmeter.conf"

echo "=========================================="
echo " Installation Apache JMeter ${JMETER_VERSION}"
echo "=========================================="

# ==========================================
# Vérification des privilèges
# ==========================================

if [ "$(id -u)" -ne 0 ]; then
    echo "ERREUR : Exécute ce script avec sudo."
    echo "Commande : sudo bash install-jmeter.sh"
    exit 1
fi

# ==========================================
# Vérification de Java
# ==========================================

echo "=== Vérification de Java ==="

if ! command -v java >/dev/null 2>&1; then
    echo "ERREUR : Java n'est pas installé."
    exit 1
fi

java -version

# ==========================================
# Vérification de l'archive
# ==========================================

echo "=== Vérification de l'archive JMeter ==="

if [ ! -f "${JMETER_ARCHIVE}" ]; then
    echo "ERREUR : Archive introuvable : ${JMETER_ARCHIVE}"
    exit 1
fi

if ! tar -tzf "${JMETER_ARCHIVE}" >/dev/null; then
    echo "ERREUR : Archive JMeter invalide."
    exit 1
fi

# ==========================================
# Création du groupe applicatif
# ==========================================

echo "=== Création du groupe applicatif ==="

if ! getent group "${JMETER_GROUP}" >/dev/null 2>&1; then
    groupadd --system "${JMETER_GROUP}"
fi

# ==========================================
# Création de l'utilisateur applicatif
# ==========================================

echo "=== Création du compte JMeter ==="

if ! id "${JMETER_USER}" >/dev/null 2>&1; then

    useradd --system \
        --gid "${JMETER_GROUP}" \
        --create-home \
        --home-dir "${JMETER_USER_HOME}" \
        --shell /sbin/nologin \
        "${JMETER_USER}"

fi

# ==========================================
# Préparation du répertoire d'installation
# ==========================================

echo "=== Préparation de l'installation ==="

mkdir -p "${JMETER_HOME}"

# ==========================================
# Extraction de JMeter
# ==========================================

echo "=== Extraction de JMeter ==="

tar -xzf "${JMETER_ARCHIVE}" \
    --strip-components=1 \
    -C "${JMETER_HOME}"

# ==========================================
# Permissions de l'installation
# ==========================================

echo "=== Configuration des permissions ==="

chown -R root:root "${JMETER_HOME}"

chmod -R a+rX "${JMETER_HOME}"

# ==========================================
# Création des répertoires de travail
# ==========================================

echo "=== Création des répertoires de travail ==="

install -d -o "${JMETER_USER}" -g "${JMETER_GROUP}" \
    "${JMETER_TESTS}"

install -d -o "${JMETER_USER}" -g "${JMETER_GROUP}" \
    "${JMETER_RESULTS}"

install -d -o "${JMETER_USER}" -g "${JMETER_GROUP}" \
    "${JMETER_REPORTS}"

# ==========================================
# Vérification de l'installation
# ==========================================

echo "=== Vérification de JMeter ==="

if [ ! -x "${JMETER_BIN}" ]; then
    echo "ERREUR : Exécutable JMeter introuvable."
    exit 1
fi

runuser -u "${JMETER_USER}" -- \
    "${JMETER_BIN}" --version

# ==========================================
# Résumé
# ==========================================

echo
echo "=========================================="
echo " Installation JMeter terminée avec succès"
echo "=========================================="

echo "Version       : ${JMETER_VERSION}"
echo "Utilisateur   : ${JMETER_USER}"
echo "Installation  : ${JMETER_HOME}"
echo "Tests         : ${JMETER_TESTS}"
echo "Résultats     : ${JMETER_RESULTS}"
echo "Rapports      : ${JMETER_REPORTS}"

echo "=========================================="
