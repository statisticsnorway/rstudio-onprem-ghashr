pkgs <- c(
    'DBI','leaflet','getPass', 'rJava','rjwsacruncher','sfarrow','Rcurl', 'esquisse','dcmodify','googleCloudStorageR','tidyfst','rJava', 'Hmisc','sdcTable', 'DT', 'configr','dggridR',
    'SmallCountRounding',
    'PxWebApiData',
    'SSBtools',
    'klassR',
    'GISSB',
    'GaussSuppression'
)
install.packages(pkgs, dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')

install.packages('/tmp/ROracle_1.4-1_R_x86_64-unknown-linux-gnu.tar.gz', repos = NULL, type='source')

install.packages('arrow', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')

