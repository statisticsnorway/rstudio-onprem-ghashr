#!/usr/bin/env Rscript

# Build-time install: manylinux portable first, noble binaries as fallback, CRAN last.
# (GHA cannot rely on Nexus; runtime Rprofile.site points at Nexus mirrors.)
#
# P3M manylinux URL must use major.minor (4.4), not patch (4.4.0).
# Empirically: .../4.4.0/... serves X-Package-Type=source; .../4.4/... serves binary.
r_ver <- Sys.getenv("R_VERSION", unset = as.character(getRversion()))
r_minor <- sub("^([0-9]+\\.[0-9]+).*", "\\1", r_ver)
manylinux <- sprintf(
  "https://packagemanager.posit.co/cran/latest/bin/linux/manylinux_2_28-x86_64/%s",
  r_minor
)
noble <- c(CRAN = "https://packagemanager.posit.co/cran/__linux__/noble/latest")
cran  <- c(CRAN = "https://cloud.r-project.org")

.libPaths(unique(c("/usr/local/lib/R/site-library", .libPaths())))
options(repos = c(P3M = manylinux, CRAN = noble[["CRAN"]]))

message("R_VERSION: ", r_ver, " → manylinux path: ", r_minor)
message("Repos: ", paste(getOption("repos"), collapse = ", "))
message(".libPaths(): ", paste(.libPaths(), collapse = " | "))

pkgs <- c(
  "RJDemetra","SmallCountRounding","PxWebApiData","openxlsx","SSBtools","GISSB",
  "GaussSuppression","tinytest","configr","DT","dcmodify","simputation","survey",
  "srvyr","eurostat","dggridR","tidyfst","plotly","klassR"
)

install_set <- function(p, repos = getOption("repos")) {
  missing <- setdiff(p, rownames(installed.packages()))
  if (length(missing)) {
    message("Installing: ", paste(missing, collapse = ", "))
    install.packages(missing, dependencies = TRUE, repos = repos, Ncpus = parallel::detectCores())
  } else {
    message("Already installed: ", paste(p, collapse = ", "))
  }
  setdiff(p, rownames(installed.packages()))
}

# 1) Manylinux portable binaries
still_missing <- install_set(pkgs, repos = manylinux)

# 2) Noble binaries for anything still missing (classic path)
if (length(still_missing)) {
  message("Noble fallback for: ", paste(still_missing, collapse = ", "))
  still_missing <- install_set(still_missing, repos = noble)
}

# 3) CRAN source last resort (historically needed for simputation)
if (length(still_missing)) {
  message("CRAN fallback for: ", paste(still_missing, collapse = ", "))
  still_missing <- install_set(still_missing, repos = cran)
}

if ("simputation" %in% still_missing || !requireNamespace("simputation", quietly = TRUE)) {
  stop("simputation did not install. Still missing: ",
       paste(setdiff(pkgs, rownames(installed.packages())), collapse = ", "),
       "\nCheck the build log above for the first error.")
}
message("simputation installed OK: ", as.character(packageVersion("simputation")))

still_missing <- setdiff(pkgs, rownames(installed.packages()))
if (length(still_missing)) {
  stop("Packages still missing after manylinux/noble/CRAN: ",
       paste(still_missing, collapse = ", "))
}

# 4) ROracle (prebuilt tarball; needs libaio/libnsl already in image)
install.packages("/tmp/ROracle_1.4-1_R_x86_64-unknown-linux-gnu.tar.gz", repos = NULL, type = "source")

# 5) GitHub packages (avoid surprise upgrades of deps)
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes", repos = manylinux)
}
gh <- c(
  "statisticsnorway/ssb-pris",
  "statisticsnorway/ssb-kostra",
  "statisticsnorway/ssb-sdcforetakperson",
  "statisticsnorway/ssb-struktur",
  "statisticsnorway/ssb-pickmdl",
  "statisticsnorway/ssb-fellesr",
  "statisticsnorway/ssb-easysdctable",
  "statisticsnorway/ReGenesees"
)
for (repo in gh) remotes::install_github(repo, upgrade = "never", dependencies = TRUE)
