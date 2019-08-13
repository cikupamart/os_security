#!/bin/bash
# ------------------------------------
# Scripts Path
# ------------------------------------
SCRIPTS_PATH="$(dirname $(readlink -m $0))/scripts"
chmod 755 ${SCRIPTS_PATH}/*.sh
exit


# ------------------------------------
# Install & Update
# ------------------------------------
# nginx headers_more module
${SCRIPTS_PATH}/headers_01_headers_more_install.sh
