#!/usr/bin/env bash
# --------------------------------------------------------------------
# /opt/install-arrow.sh
# Install R arrow as Posit portable (manylinux_2_28) binary — no APT/system libs.
# --------------------------------------------------------------------
set -euo pipefail

: "${ARROW_VERSION:?ARROW_VERSION (e.g. 24.0.0) must be exported}"
: "${R_VERSION:?R_VERSION (e.g. 4.4.0) must be exported}"

# P3M manylinux path must be major.minor (4.4), NOT patch (4.4.0).
# With 4.4.0, P3M returns X-Package-Type=source and packages compile (and fail).
R_MINOR="${R_VERSION%.*}"

# GHA/build: public P3M (Nexus often unreachable). Runtime users use Nexus via Rprofile.site.
REPOS="https://packagemanager.posit.co/cran/latest/bin/linux/manylinux_2_28-x86_64/${R_MINOR}"

echo "▶  Arrow portable binary : ${ARROW_VERSION}"
echo "    ↪ R_VERSION          : ${R_VERSION} → path ${R_MINOR}"
echo "    ↪ repos              : ${REPOS}"

Rscript --vanilla -e "install.packages('remotes', repos='${REPOS}', quiet=TRUE)"
Rscript --vanilla -e "remotes::install_version('arrow', version='${ARROW_VERSION}', repos='${REPOS}', dependencies=c('Depends','Imports','LinkingTo'), upgrade='never')"

# Assert load + capabilities (avoid heredoc — CRLF-safe in CI)
Rscript --vanilla -e "caps <- arrow::arrow_info()\$capabilities; print(caps); if (is.null(caps) || !any(unlist(caps))) stop('arrow capabilities all FALSE'); message('arrow ', as.character(packageVersion('arrow')), ' OK')"

echo "✅  arrow ${ARROW_VERSION} (portable manylinux) installed."
