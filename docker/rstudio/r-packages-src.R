pkgs <- c(
    'RJDemetra',
    'SmallCountRounding',
    'PxWebApiData',
    'openxlsx',
    'SSBtools',
    'GISSB',
    'GaussSuppression', 
    'tinytest', 
    'configr', 
    'DT', 
    'dcmodify', 
    'simputation', 
    'survey', 
    'srvyr', 
    'eurostat', 
    'dggridR', 
    'tidyfst')

install.packages(pkgs, dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')

install.packages('/tmp/ROracle_1.4-1_R_x86_64-unknown-linux-gnu.tar.gz', repos = NULL, type='source')

remotes::install_github('statisticsnorway/ssb-pris')
remotes::install_github('statisticsnorway/ssb-kostra')
remotes::install_github('statisticsnorway/ssb-sdcforetakperson')
remotes::install_github('statisticsnorway/ssb-struktur')
remotes::install_github('statisticsnorway/ssb-fellesr', dependencies=TRUE, verbose=TRUE)
remotes::install_github('statisticsnorway/ssb-easysdctable', dependencies=TRUE, verbose=TRUE)
remotes::install_github('statisticsnorway/ReGenesees')

#install.packages('arrow', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')

