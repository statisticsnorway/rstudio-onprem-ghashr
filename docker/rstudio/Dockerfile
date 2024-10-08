FROM rocker/r-ver:4.4.0

ARG openjdk_version="17" ########### Open Java-dev-kit
USER root

# We will install R and packages using instructions from https://cloud.r-project.org/
# Should be installed into /usr/lib/R/site-library
RUN apt-get update -y \
    && apt-get -y upgrade \
    && apt-get -y dist-upgrade \
    && apt-get install -y --no-install-recommends "openjdk-${openjdk_version}-jdk-headless" ca-certificates-java \
    software-properties-common dirmngr build-essential wget curl libssl-dev libcurl4-openssl-dev libglpk-dev libgdal-dev libre2-dev \
    apt-utils libudunits2-dev cmake lsb-release gpg-agent libssh-dev libsodium-dev gfortran cargo libcairo2-dev zlib1g-dev \
    # add the signing key (by Michael Rutter) for these repos
    # To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
    # Fingerprint: 298A3A825C0D65DFD57CBB651716619E084DAB9
    && wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
    | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc \
    # add the R 4.0 repo from CRAN -- adjust 'focal' to 'groovy' or 'bionic' as needed
    && add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" \
    # Install arrow libraries, see:  \
    # https://github.com/kou/arrow-site/blob/main/install.md#c-and-glib-c-packages-for-debian-gnulinux-ubuntu-almalinux-centos-and-amazon-linux
    && wget https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb \
    && apt install -y ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb \
    && apt update \
    && apt-get install -y libarrow-dev libarrow-glib-dev libarrow-dataset-dev libarrow-dataset-glib-dev libarrow-acero-dev libarrow-flight-dev libarrow-flight-glib-dev \
    libarrow-flight-sql-dev libarrow-flight-sql-glib-dev libgandiva-dev libgandiva-glib-dev libparquet-dev libparquet-glib-dev \
    # add git repo
    && add-apt-repository -y ppa:git-core/ppa \
    && gpg-agent --daemon \
    # Get access to 5000+ CRAN Packages
    && add-apt-repository -y ppa:c2d4u.team/c2d4u4.0+ \
    && apt-get update -y \
    && apt-get upgrade -y \
    && apt autoremove -y \
    && apt-get -y clean all \
    && rm -rf /var/lib/apt/lists/*

# Adding packages 
COPY r-packages.txt /tmp/r-packages.txt

RUN R CMD javareconf -e \
    && apt-get update -y \
    && apt-get -y upgrade \
    && apt-get -y dist-upgrade \
    # vim support
    && apt-get -y install vim \
    # Installing bsdmainutils, helped solve colrm message after every command in the terminal
    && apt-get install -y bsdmainutils \
    && apt-get -y install libbz2-dev \
    #Added this to add packages from :
    && xargs apt-get install -y --no-install-recommends < /tmp/r-packages.txt \ 
    && apt autoremove -y \
    && apt-get -y clean all \
    && rm -rf /var/lib/apt/lists/*


# Installing sssd-tools (required for authentication)
RUN apt update && \
    apt-get -y clean all && \
    apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y dist-upgrade && \
    apt-get -y install openssh-client && \
    apt-get -y install sssd-tools && \
    apt-get -y install wget && \
    apt-get -y install cron

# Added repository for libpoppler-cpp-dev, and installed dependencies for tesseract ################# This is for displaying pdfs (libpoppler) and text-reading (tessaract)
RUN apt-get update -y && \
    apt-get install -y software-properties-common && \
    apt-get install -y libpoppler-cpp-dev libtesseract-dev tesseract-ocr-eng tesseract-ocr-nor && \
    apt-get install -y libmagick++-dev

# Added dependencies for ProtoBuf  #################### Serializing structured data
RUN apt-get update -y && \
    apt-get install -y libprotoc-dev libprotobuf-dev protobuf-compiler

# ENV S6_VERSION=v2.1.0.2
# ENV RSTUDIO_VERSION=2022.07.2+576
# These are being set in Rockers image, so don't use these
# https://github.com/rocker-org/rocker-versioned2/blob/5fa99b369510466ea8a2803d29e3417f5212a0fc/dockerfiles/rstudio_4.3.1.Dockerfile#L9
ENV DEFAULT_USER=rstudio
ENV PANDOC_VERSION=default
ENV QUARTO_VERSION=default
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

RUN /rocker_scripts/install_rstudio.sh && \
    /rocker_scripts/install_pandoc.sh && \
    /rocker_scripts/install_quarto.sh && \
    #/rocker_scripts/install_texlive.sh && \
    /rocker_scripts/install_tensorflow.sh && \
    /rocker_scripts/install_tidyverse.sh && \
    apt-get -y update && \
    # installing texlive via apt instead, the built in install_texlive doesnt supply everything
    apt-get -y install texlive-full && \
    # alien is a helper to install oracle instantclient
    apt-get install -y --no-install-recommends alien && \
    # installing yad (yet another dialog)
    apt-get -y install yad && \
    apt-get install -y iputils-ping && \
    apt-get install -y --no-install-recommends libaio1 libaio-dev

ENV R_HOME /usr/local/lib/R
ENV R_LIBS_USER /usr/local/lib/R/library

# Change default R repo
COPY Rprofile.site /etc/R/Rprofile.site
COPY Rprofile.site /usr/local/lib/R/etc/Rprofile.site

RUN R --no-echo -e "library(tidyverse)"
RUN R --no-echo -e "library(rJava)"

# Setting up environment variables for oracle and R
ENV OCI_INC=/usr/include/oracle/21/client64
ENV OCI_LIB=/usr/lib/oracle/21/client64/lib
ENV ORACLE_HOME=/usr/lib/oracle/21/client64
ENV TNS_ADMIN=/usr/lib/oracle/21/client64/lib/network
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/oracle/21/client64/lib

# Downloading oracle instant-client components and saving to /tmp
RUN wget https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-basic-21.6.0.0.0-1.x86_64.rpm -P /tmp/ && \
    wget https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-devel-21.6.0.0.0-1.x86_64.rpm -P /tmp/ && \
    wget https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-sqlplus-21.6.0.0.0-1.x86_64.rpm -P /tmp/ && \
    wget https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-odbc-21.6.0.0.0-1.x86_64.rpm -P /tmp/ && \
    wget https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-jdbc-21.6.0.0.0-1.x86_64.rpm -P /tmp/ && \
    wget https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-tools-21.6.0.0.0-1.x86_64.rpm -P /tmp/

# Installing oracle-instantclient components using alien
RUN alien -i /tmp/oracle-instantclient-basic-21.6.0.0.0-1.x86_64.rpm && \
    alien -i /tmp/oracle-instantclient-devel-21.6.0.0.0-1.x86_64.rpm && \
    alien -i /tmp/oracle-instantclient-odbc-21.6.0.0.0-1.x86_64.rpm && \
    alien -i /tmp/oracle-instantclient-jdbc-21.6.0.0.0-1.x86_64.rpm && \
    alien -i /tmp/oracle-instantclient-tools-21.6.0.0.0-1.x86_64.rpm && \
    # Must install sqlplus seperately because of an issue installing using alien
    cd /tmp && \
    rpm2cpio /tmp/oracle-instantclient-sqlplus-21.6.0.0.0-1.x86_64.rpm | cpio -idmv && \
    sudo cp -r /tmp/usr/* /usr/ && \
    rm -rf /tmp/usr && \
    ldconfig && \
    rm -rf /tmp/oracle-instantclient-*

# https://cran.r-project.org/web/packages/arrow/vignettes/install.html
ENV NOT_CRAN true
ENV ARROW_GCS=ON

COPY jwsacruncher-2.2.4.zip /tmp/jwsacruncher-2.2.4.zip

# Copy the ROracle installation file into the container
COPY ROracle_1.4-1_R_x86_64-unknown-linux-gnu.tar.gz /tmp/ROracle_1.4-1_R_x86_64-unknown-linux-gnu.tar.gz

# Setup R java support and install R packages that are not available as Ubuntu packages
COPY r-packages-src.R /tmp/r-packages-src.R
RUN R CMD javareconf -e \
    && Rscript /tmp/r-packages-src.R \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
    # Doesn t work with Java11 - use a custom one
    && unzip /tmp/jwsacruncher-2.2.4.zip -d /opt && rm -f /tmp/jwsacruncher-2.2.4.zip \
    # Create a symlink at /usr/bin so users can call jwsacruncher from anywhere
    && ln -s /opt/jwsacruncher-2.2.4/bin/jwsacruncher /usr/bin/jwsacruncher

#COPY r-packages-git.R /tmp/r-packages-git.R
#RUN Rscript /tmp/r-packages-git.R    


# add tnsnames.ora to oracle path
RUN ln -s /ssb/share/etc/tnsnames.ora /usr/lib/oracle/21/client64/lib/network/tnsnames.ora

# symlink to /ssb/share/etc/stamme_variabel
RUN ln -s /ssb/share/etc/stamme_variabel /etc/profile.d/stamme_variabel

RUN mkdir -p /usr/local/share/etc/
COPY bashrc.felles /usr/local/share/etc/bashrc.felles

# Set FELLES environment variable
ENV FELLES=/ssb/bruker/felles
ENV ARROW_GCS=OFF
ENV ARROW_S3=OFF
ENV ARROW_THIRDPARTY_DEPENDENCY_DIR=/ssb/bruker/felles/R_pakker/arrow

# Set localtime to Europe/Oslo
ENV TZ=Europe/Oslo
RUN rm -f /etc/localtime && \
    ln -s /usr/share/zoneinfo/Europe/Oslo /etc/localtime

# adding a custom bashrc with git branch in PS1
COPY default-bashrc /etc/skel/.bashrc

COPY check-git-config.bash /usr/local/bin/check-git-config.sh
RUN chmod +x /usr/local/bin/check-git-config.sh

# Install ssb-gitconfig.py script
RUN wget -O /usr/local/bin/ssb-gitconfig.py https://raw.githubusercontent.com/statisticsnorway/kvakk-git-tools/main/kvakk_git_tools/ssb_gitconfig.py
RUN chmod +x /usr/local/bin/ssb-gitconfig.py

# Appends ssh-rsa as the accepted algorithm to /etc/ssh/ssh_config
# using printf instead of echo -e because the option -e gets appended to the file,
# and i could not find a working solution other than printf or copying the file from repo to image
RUN printf "    PubkeyAcceptedAlgorithms +ssh-rsa\n    HostkeyAlgorithms +ssh-rsa" >> /etc/ssh/ssh_config

# Use proxy for https connections, this must happen last
ENV https_proxy=http://proxy.ssb.no:3128
ENV no_proxy=nexus.ssb.no,git-adm.ssb.no,i.test.ssb.no,i.ssb.no,data.ssb.no,github.com,api.github.com,codeload.github.com,www.ssb.no
# Set Dapla environment variables used to identify the service.
ENV DAPLA_SERVICE=R_STUDIO
ENV DAPLA_REGION=ON_PREM
# Custom startup script which calls the original startup script /init at the end
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8787

CMD ["/start.sh"]
