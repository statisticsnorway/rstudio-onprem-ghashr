pkgs = c(
  'statisticsnorway/ssb-pris',
  'statisticsnorway/ssb-kostra',
  'statisticsnorway/ssb-sdcforetakperson',
  'statisticsnorway/ssb-struktur',
  'statisticsnorway/ssb-fellesr', # dependencies=TRUE, verbose=TRUE ??
  'statisticsnorway/ssb-easysdctable',
  'statisticsnorway/ReGenesees'
)

remotes::install_github(pkgs)
