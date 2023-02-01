FROM rocker/binder

ARG openjdk_version="17"
USER root

# We will install R and packages using instructions from https://cloud.r-project.org/
# Should be installed into /usr/lib/R/site-library
#RUN apt-get update -y \
#    && apt-get -y upgrade \
#    && apt-get -y dist-upgrade \
#    && apt-get -y install wget \
#    && apt-get install -y --no-install-recommends "openjdk-${openjdk_version}-jdk-headless" ca-certificates-java \
#    software-properties-common dirmngr build-essential curl libssl-dev libcurl4-openssl-dev libgdal-dev libre2-dev \
#    apt-utils libudunits2-dev cmake lsb-release gpg-agent libssh-dev \
    # add the signing key (by Michael Rutter) for these repos
    # To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
    # Fingerprint: 298A3A825C0D65DFD57CBB651716619E084DAB9
#    && wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
#    | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc \
    # add the R 4.0 repo from CRAN -- adjust 'focal' to 'groovy' or 'bionic' as needed
#    && add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" \
#    && gpg-agent --daemon \
    # Get access to 5000+ CRAN Packages
#    && add-apt-repository -y ppa:c2d4u.team/c2d4u4.0+ \
#    && apt autoremove -y \
#    && apt-get -y clean all \
#    && rm -rf /var/lib/apt/lists/*

ENV R_HOME /usr/local/lib/R
ENV R_LIBS_USER /usr/local/lib/R/library

# Setting up environment variables for oracle and R
#ENV OCI_INC=/usr/include/oracle/21/client64
#ENV OCI_LIB=/usr/lib/oracle/21/client64/lib
#ENV ORACLE_HOME=/usr/lib/oracle/21/client64
#ENV TNS_ADMIN=/usr/lib/oracle/21/client64/lib/network
#ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/oracle/21/client64/lib

# Downloading oracle instant-client components and saving to /tmp
#RUN wget https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-basic-21.6.0.0.0-1.x86_64.rpm -P /tmp/ && \
#    wget https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-devel-21.6.0.0.0-1.x86_64.rpm -P /tmp/ && \
#    wget https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-sqlplus-21.6.0.0.0-1.x86_64.rpm -P /tmp/ && \
#    wget https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-odbc-21.6.0.0.0-1.x86_64.rpm -P /tmp/ && \
#    wget https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-jdbc-21.6.0.0.0-1.x86_64.rpm -P /tmp/ && \
#    wget https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-tools-21.6.0.0.0-1.x86_64.rpm -P /tmp/

#RUN apt update && \
#    # alien is used to convert .rpms to .deb packages
#    apt-get install -y alien && \
#    # Installing ping
#    apt-get install -y iputils-ping && \
#    # libaio required by oracle 64-bit client
#    apt-get install -y libaio1 libaio-dev && \
#    apt autoremove -y && \
#    apt-get -y clean all

# Installing oracle-instantclient components using alien
#RUN alien -i /tmp/oracle-instantclient-basic-21.6.0.0.0-1.x86_64.rpm && \
#    alien -i /tmp/oracle-instantclient-devel-21.6.0.0.0-1.x86_64.rpm && \
#    alien -i /tmp/oracle-instantclient-sqlplus-21.6.0.0.0-1.x86_64.rpm && \
#    alien -i /tmp/oracle-instantclient-odbc-21.6.0.0.0-1.x86_64.rpm && \
#    alien -i /tmp/oracle-instantclient-jdbc-21.6.0.0.0-1.x86_64.rpm && \
#    alien -i /tmp/oracle-instantclient-tools-21.6.0.0.0-1.x86_64.rpm && \
#    rm -rf /tmp/oracle-instantclient-*

# https://cran.r-project.org/web/packages/arrow/vignettes/install.html
#ENV NOT_CRAN true
#ENV ARROW_GCS=ON

#COPY r-packages.txt /tmp/r-packages.txt

#RUN apt-get update -y && \
#    # vim support
#    apt-get -y install vim && \
#    # required for json parsing using bash
#    apt-get -y install jq && \
#    # used to find and kill files user have open
#    apt-get -y install lsof && \
#    # installing texlive-full
#    apt-get -y install texlive-full && \
#    # Installing bsdmainutils, helped solve colrm message after every command in the terminal
#    apt-get install -y bsdmainutils && \
#    xargs apt-get install -y --no-install-recommends < /tmp/r-packages.txt && \
#    apt autoremove -y && \
#    apt-get -y clean all && \
#    rm -rf /var/lib/apt/lists/*

#COPY jwsacruncher-2.2.4.zip /tmp/jwsacruncher-2.2.4.zip

# Setup R java support and install R packages that are not available as Ubuntu packages
#RUN R CMD javareconf -e && \
#    R -e "install.packages('ROracle', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('RTextTools', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('configr', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('SSBtools', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('RegSDC', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('oysteR', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('writexl', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('concaveman', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('cppRouting', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('rjwsacruncher', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('klassR', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('antiword', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('textshape', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('striprtf', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('textreadr', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('terra', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('raster', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('leaflet', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('languageserver', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('sotkanet', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('ggiraph', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('dcmodify', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('simputation', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('arrow', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "remotes::install_github('r-barnes/dggridR', vignette=TRUE)" && \
#    R -e "remotes::install_github('statisticsnorway/Kostra')" && \
#    R -e "remotes::install_github('statisticsnorway/SdcForetakPerson')" && \
#    R -e "remotes::install_github('statisticsnorway/struktuR')" && \
#    R -e "install.packages('dotenv', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('PriceIndices', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    R -e "install.packages('sfarrow', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
#    rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
#    # Doesn t work with Java11 - use a custom one
#    unzip /tmp/jwsacruncher-2.2.4.zip -d /opt && rm -f /tmp/jwsacruncher-2.2.4.zip && \
#    # Create a symlink at /usr/bin so users can call jwsacruncher from anywhere
#    ln -s /opt/jwsacruncher-2.2.4/bin/jwsacruncher /usr/bin/jwsacruncher


# add tnsnames.ora to oracle path
#RUN ln -s /ssb/share/etc/tnsnames.ora /usr/lib/oracle/21/client64/lib/network/tnsnames.ora

# Allowing usage of stamme_variabler in the terminal
# stamme_variabler is also useable in the kernels as
# the file is sourced before the kernels start
#RUN ln -s /ssb/share/etc/stamme_variabel /etc/profile.d/stamme_variabel

RUN mkdir -p /usr/local/share/etc/
COPY bashrc.felles /usr/local/share/etc/bashrc.felles

# Change default R repo
COPY Rprofile.site /usr/local/lib/R/etc

# Set FELLES environment variable
ENV FELLES=/ssb/bruker/felles

# Set localtime to Europe/Oslo
RUN rm -f /etc/localtime && \
    ln -s /usr/share/zoneinfo/Europe/Oslo /etc/localtime

# Installing quarto https://quarto.org/
# not installing .deb file because some features don't work
#RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.2.262/quarto-1.2.262-linux-amd64.tar.gz -P /tmp/ && \
#    tar -zxf /tmp/quarto-1.2.262-linux-amd64.tar.gz -C /usr/local/ && \
#    ln -s /usr/local/quarto-1.2.262/bin/quarto /usr/local/bin/quarto && \
#    rm -rf /tmp/quarto-1.2.262-linux-amd64.tar.gz

# adding a custom bashrc with git branch in PS1
COPY common-bashrc /etc/skel/.bashrc

# Install ssb-gitconfig.py script
#RUN wget -O /usr/local/bin/ssb-gitconfig.py https://raw.githubusercontent.com/statisticsnorway/kvakk-git-tools/main/ssb-gitconfig/ssb-gitconfig.py
#RUN chmod +x /usr/local/bin/ssb-gitconfig.py

COPY check-git-config.bash /usr/local/bin/check-git-config.sh
RUN chmod +x /usr/local/bin/check-git-config.sh

# Use proxy for https connections, this must happen last
ENV https_proxy=http://proxy.ssb.no:3128
ENV no_proxy=nexus.ssb.no,git-adm.ssb.no,i.test.ssb.no,i.ssb.no

USER $NB_UID

CMD ["/init"]