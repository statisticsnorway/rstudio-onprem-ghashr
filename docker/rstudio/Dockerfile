FROM rocker/geospatial:4.4.1

USER root

ARG openjdk_version="17"
ARG libarrow_version="18.1.0"
 
RUN R --no-echo -e "cat(Sys.getenv('R_HOME'), Sys.getenv('R_LIBS_USER'),'\n');cat(.libPaths(),'\n'); print(installed.packages()[,c('Package', 'Version')])"
 
# Add Arrow repository and set up package pinning
RUN apt-get update -y \
    && apt-get -y upgrade \
    && apt-get -y dist-upgrade \
    # && apt-get install -y --no-install-recommends "openjdk-${openjdk_version}-jdk-headless" ca-certificates-java \
    && apt-get install -y --no-install-recommends "openjdk-${openjdk_version}-jdk" ca-certificates-java \
    software-properties-common dirmngr build-essential wget curl libssl-dev libcurl4-openssl-dev libglpk-dev libgdal-dev libre2-dev \
    apt-utils libudunits2-dev cmake lsb-release gpg-agent libssh-dev libsodium-dev gfortran cargo libcairo2-dev zlib1g-dev 
    
RUN wget "https://apache.jfrog.io/artifactory/arrow/ubuntu/pool/jammy/main/a/apache-arrow-apt-source/apache-arrow-apt-source_${libarrow_version}-1_all.deb" && \
    apt-get update && \
    apt-get install -y ./apache-arrow-apt-source_${libarrow_version}-1_all.deb && \
    rm ./apache-arrow-apt-source_${libarrow_version}-1_all.deb && \
    apt-get update

 # Sjekk tilgjengelige versjoner for libarrow- dev (valgfritt, for feilsøking)
RUN echo "=== apt-cache policy for libarrow-dev ===" && apt-cache policy libarrow-dev

# Sett opp apt-pinning for Apache Arrow
RUN echo "Package: libarrow-dev libarrow-glib-dev libarrow-dataset-dev libarrow-dataset-glib-dev libarrow-acero-dev libarrow-flight-dev libarrow-flight-glib-dev libarrow-flight-sql-dev libarrow-flight-sql-glib-dev libgandiva-dev libgandiva-glib-dev libparquet-dev libparquet-glib-dev gir1.2-arrow-1.0 gir1.2-arrow-dataset-1.0 gir1.2-arrow-flight-1.0 gir1.2-arrow-flight-sql-1.0 gir1.2-gandiva-1.0 gir1.2-parquet-1.0\nPin: version ${libarrow_version}\nPin-Priority: 1001" > /etc/apt/preferences.d/arrow-pinning && \
    apt-get update

# Installer Apache Arrow-pakkene med den spesifikke versjonen
RUN apt-get install -y \
    libarrow-dev=${libarrow_version}-1 \
    libarrow-glib-dev=${libarrow_version}-1 \
    libarrow-dataset-dev=${libarrow_version}-1 \
    libarrow-dataset-glib-dev=${libarrow_version}-1 \
    libarrow-acero-dev=${libarrow_version}-1 \
    libarrow-flight-dev=${libarrow_version}-1 \
    libarrow-flight-glib-dev=${libarrow_version}-1 \
    libarrow-flight-sql-dev=${libarrow_version}-1 \
    libarrow-flight-sql-glib-dev=${libarrow_version}-1 \
    gir1.2-arrow-dataset-1.0=${libarrow_version}-1 \
    gir1.2-arrow-flight-1.0=${libarrow_version}-1 \
    gir1.2-arrow-flight-sql-1.0=${libarrow_version}-1 \
    gir1.2-arrow-1.0=${libarrow_version}-1 \
    gir1.2-gandiva-1.0=${libarrow_version}-1 \
    gir1.2-parquet-1.0=${libarrow_version}-1 \
    libgandiva-dev=${libarrow_version}-1 \
    libgandiva-glib-dev=${libarrow_version}-1 \
    libparquet-dev=${libarrow_version}-1 \
    libparquet-glib-dev=${libarrow_version}-1 \
    
    # add git repo
    && add-apt-repository -y ppa:git-core/ppa \
    && gpg-agent --daemon \
    # alien is a helper to install oracle instantclient
    && apt-get install -y --no-install-recommends alien  \
    && apt-get -y update  \
    # installing texlive via apt instead, the built-in install_texlive doesn't supply everything
    #&& apt-get -y install texlive-full \
    && apt-get install -y `apt-get --assume-no install texlive-full | \
		awk '/The following additional packages will be installed/{f=1;next} /Suggested packages/{f=0} f' | \
		tr ' ' '\n' | grep -vP 'doc$' | grep -vP 'texlive-lang' | grep -vP 'latex-cjk' | tr '\n' ' '` \
    # installing yad (yet another dialog)
    && apt-get -y install yad  \
    && apt-get install -y iputils-ping  \
    && apt-get install -y --no-install-recommends libaio1 libaio-dev \
    && apt-get update -y \
    && apt-get upgrade -y \
    && apt autoremove -y \
    && apt-get -y clean all \
    && rm -rf /var/lib/apt/lists/*

# Set R environment variables
ENV R_HOME=/usr/local/lib/R
ENV R_LIBS_USER=/usr/local/lib/R/library

# Setting up environment variables for Oracle
ENV OCI_INC=/usr/include/oracle/21/client64
ENV OCI_LIB=/usr/lib/oracle/21/client64/lib
ENV ORACLE_HOME=/usr/lib/oracle/21/client64
ENV TNS_ADMIN=/usr/lib/oracle/21/client64/lib/network
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/lib/oracle/21/client64/lib

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
    cp -r /tmp/usr/* /usr/ && \
    rm -rf /tmp/usr && \
    ldconfig && \
    rm -rf /tmp/oracle-instantclient-*

# Copy the ROracle installation file into the container
COPY ROracle_1.4-1_R_x86_64-unknown-linux-gnu.tar.gz /tmp/ROracle_1.4-1_R_x86_64-unknown-linux-gnu.tar.gz

# Copy Jwsacruncher
COPY jwsacruncher-2.2.4.zip /tmp/jwsacruncher-2.2.4.zip

# Copy R-script that installs packages from source
COPY r-packages-src.R /tmp/r-packages-src.R

# Install additional packages from source
RUN Rscript /tmp/r-packages-src.R \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
    # Doesn t work with Java11 - use a custom one
    && unzip /tmp/jwsacruncher-2.2.4.zip -d /opt && rm -f /tmp/jwsacruncher-2.2.4.zip \
    # Create a symlink at /usr/bin so users can call jwsacruncher from anywhere
    && ln -s /opt/jwsacruncher-2.2.4/bin/jwsacruncher /usr/bin/jwsacruncher

RUN R --no-echo -e "cat(Sys.getenv('R_HOME'), Sys.getenv('R_LIBS_USER'),'\n');cat(.libPaths(),'\n'); print(installed.packages()[,c('Package', 'Version')])"

# Change default R repo (used by renv)
COPY Rprofile.site /etc/R/Rprofile.site
COPY Rprofile.site /usr/local/lib/R/etc/Rprofile.site

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

# Added repository for libpoppler-cpp-dev, and installed dependencies for tesseract
RUN apt-get update -y && \
    apt-get install -y software-properties-common && \
    apt-get install -y libpoppler-cpp-dev libtesseract-dev tesseract-ocr-eng tesseract-ocr-nor && \
    apt-get install -y libmagick++-dev

# Added dependencies for ProtoBuf
RUN apt-get update -y && \
    apt-get install -y libprotoc-dev libprotobuf-dev protobuf-compiler

# add tnsnames.ora to oracle path
RUN ln -s /ssb/share/etc/tnsnames.ora /usr/lib/oracle/21/client64/lib/network/tnsnames.ora

# symlink to /ssb/share/etc/stamme_variabel
RUN ln -s /ssb/share/etc/stamme_variabel /etc/profile.d/stamme_variabel

RUN mkdir -p /usr/local/share/etc/
COPY bashrc.felles /usr/local/share/etc/bashrc.felles

# Set FELLES environment variable
ENV FELLES=/ssb/bruker/felles
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

