#!/usr/bin/env bash
# --------------------------------------------------------------------
# /opt/install-arrow.sh
# Install R arrow as Posit portable (manylinux_2_28) binary — no APT/system libs.
# --------------------------------------------------------------------
set -euo pipefail

: "${ARROW_VERSION:?ARROW_VERSION (e.g. 24.0.0) must be exported}"
: "${R_VERSION:?R_VERSION (e.g. 4.4.0) must be exported}"

# GHA/build: public P3M (Nexus often unreachable). Runtime users use Nexus via Rprofile.site.
REPOS="https://packagemanager.posit.co/cran/latest/bin/linux/manylinux_2_28-x86_64/${R_VERSION}"

echo "▶  Arrow portable binary : ${ARROW_VERSION}"
echo "    ↪ R_VERSION          : ${R_VERSION}"
echo "    ↪ repos              : ${REPOS}"

Rscript --vanilla -e "install.packages('remotes', repos='${REPOS}', quiet=TRUE)"
Rscript --vanilla -e "remotes::install_version('arrow', version='${ARROW_VERSION}', repos='${REPOS}', dependencies=c('Depends','Imports','LinkingTo'), upgrade='never')"

Rscript --vanilla <<'RS'
caps <- arrow::arrow_info()$capabilities
print(caps)
if (is.null(caps) || !any(unlist(caps))) {
  stop("arrow installed but capabilities are all FALSE / unavailable")
}
message("arrow ", as.character(packageVersion("arrow")), " OK")
RS

echo "✅  arrow ${ARROW_VERSION} (portable manylinux) installed."
