FROM docker.io/library/ubuntu:noble

# System-wide configuration
SHELL ["/bin/bash", "-c"]
ENV SHELL="/bin/bash"
ENV DEBIAN_FRONTEND="noninteractive"

# Setup user & workspace
ENV USERNAME="rstudio"
ENV UID="1000"
ENV GROUPNAME="users"
ENV GID="100"
ENV HOME="/home/${USERNAME}"
ENV WORKSPACE_DIR="${HOME}/work"
RUN groupmod -g ${GID} ${GROUPNAME} && \
    # If user by ID 1000 already exists, remove it so we can re-create it
    if id -u ${UID} >/dev/null 2>&1; then userdel -r $(getent passwd ${UID} | cut -d: -f1); fi && \
    # Setup custom user with sudo rights
    useradd ${USERNAME} --uid=${UID} -g ${GROUPNAME} --groups sudo -r --no-log-init --create-home && \
    # Create workspace
    mkdir -p ${WORKSPACE_DIR} && \
    # Disable default sudo message when opening shell
    touch ${HOME}/.sudo_as_admin_successful

WORKDIR ${WORKSPACE_DIR}

USER root

## `../scripts` directory should be added by the --build-context flag like so:
## docker build --build-context scripts=../scripts <REST>
COPY scripts/ /opt/

RUN chmod -R +x /opt/ && \
    # Install essential system libraries
    /opt/install-system-libs.sh && \
    apt-get upgrade -y && \
    # Generate locales
    locale-gen nb_NO.UTF-8 && \
    # Update default locale to Norwegian
    update-locale LANG=nb_NO.UTF-8 && \
    # Make sudo passwordless
    echo '${USERNAME} ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    # Fix permissions
    chown -R ${USERNAME}:${GROUPNAME} ${HOME} && \
    chmod +x /opt/onyxia-init.sh && \
    # Clean up
    rm -rf /var/lib/apt/lists/*

ENV PATH="${PATH}:${HOME}/.local/bin:${HOME}/.krew/bin:${HOME}/work/.local/pipx/bin"

# Download git completion and git prompt scripts (sjekke om dete er nødvendig mtp at vi kopierer inn bashrc fra L219)
RUN curl -o ${HOME}/.git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash && \
    curl -o ${HOME}/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh && \
    chown ${USERNAME}:${GROUPNAME} ${HOME}/.git-completion.bash ${HOME}/.git-prompt.sh && \
    echo "source ~/.git-completion.bash" >> ${HOME}/.bashrc && \
    echo "source ~/.git-prompt.sh" >> ${HOME}/.bashrc && \
    echo 'export PS1="\[\e[1;32m\]\u@\h:\[\e[1;34m\]\w\[\e[1;31m\]\$(__git_ps1 \" (%s)\")\[\e[0m\]\$ "' >> ${HOME}/.bashrc

# Set locales
ENV LANG=nb_NO.UTF-8
ENV LANGUAGE=nb_NO:nb
ENV LC_ALL=nb_NO.UTF-8

USER 1000

# Install gitconfig file from kvakk-git-tools
RUN /opt/install-gitconfig.sh

# R Config
ARG R_VERSION="4.4.1"
ENV R_VERSION=${R_VERSION}
ENV R_HOME="/usr/local/lib/R"
ENV DEFAULT_USER="${USERNAME}"

# Java configuration
ARG JAVA_VERSION="17"
ENV JAVA_VERSION=${JAVA_VERSION}
ENV JAVA_HOME="/usr/lib/jvm/java-$JAVA_VERSION-openjdk-amd64"
ENV PATH="${JAVA_HOME}/bin:${PATH}"

USER root

RUN apt-get upgrade --fix-missing -y

# Install R using rocker's install scripts
RUN git clone --branch R4.5.0 --depth 1 https://github.com/rocker-org/rocker-versioned2.git /tmp/rocker-versioned2 && \
    cp -r /tmp/rocker-versioned2/scripts/ /rocker_scripts/ && \
    chown -R ${USERNAME}:${GROUPNAME} /rocker_scripts/ && \
    chmod -R 700 /rocker_scripts/ && \
    /rocker_scripts/install_R_source.sh

ENV CRAN="https://p3m.dev/cran/__linux__/noble/latest"

# RStudio ENVs
ENV S6_VERSION=v2.1.0.2
ENV RSTUDIO_VERSION=stable
ENV DEFAULT_USER=rstudio
ENV PANDOC_VERSION=default
ENV QUARTO_VERSION=default

# LaTeX ENVs
ENV CTAN_REPO=https://mirror.ctan.org/systems/texlive/tlnet
ENV PATH=$PATH:/usr/local/texlive/bin/linux

COPY jwsacruncher-2.2.4.zip /tmp/jwsacruncher-2.2.4.zip

# Set up R (RSPM, OpenBLAS, littler, addtional packages)
RUN /opt/install-java.sh
    # Install R
RUN /rocker_scripts/setup_R.sh
    # Install RStudio
RUN /rocker_scripts/install_quarto.sh 
# Install geospatial packages
RUN /rocker_scripts/install_tidyverse.sh
# RUN /rocker_scripts/install_verse.sh
RUN /rocker_scripts/install_geospatial.sh
RUN /rocker_scripts/install_pandoc.sh
RUN /rocker_scripts/install_rstudio.sh

    # Re-install system libs that may have been removed by autoremove in rocker scripts
RUN /opt/install-system-libs.sh && \
    # Install additional system libs needed by R packages
    /opt/install-system-libs-R.sh && \
    # Configure R for CUDA if parent image has CUDA
    if ! [[ -z "${CUDA_VERSION}" ]]; then /rocker_scripts/config_R_cuda.sh; fi && \
    # Install useful additional packages
    install2.r --error \
    devtools \
    DBI \
    lintr \
    quarto \
    renv \
    styler && \
    unzip /tmp/jwsacruncher-2.2.4.zip -d /opt && rm -f /tmp/jwsacruncher-2.2.4.zip && \
    # Create a symlink at /usr/bin so users can call jwsacruncher from anywhere
    ln -s /opt/jwsacruncher-2.2.4/bin/jwsacruncher /usr/bin/jwsacruncher && \
    # Fix permissions
    chown -R ${USERNAME}:${GROUPNAME} ${HOME} ${R_HOME} && \
    # Clean
    rm -rf /var/lib/apt/lists/*


# Install Arrow, og sjekk https://cran.r-project.org/src/contrib/Archive/arrow/ om R-versjonen ligger der. Slik at du treffer riktig versjon. Bruk også "apt-cache madison libarrow-dev"
ARG ARROW_VERSION="18.1.0"
ENV ARROW_VERSION=${ARROW_VERSION}
RUN /opt/install-arrow.sh

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
    alien -i /tmp/oracle-instantclient-sqlplus-21.6.0.0.0-1.x86_64.rpm

# Copy the ROracle installation file into the container
COPY ROracle_1.4-1_R_x86_64-unknown-linux-gnu.tar.gz /tmp/ROracle_1.4-1_R_x86_64-unknown-linux-gnu.tar.gz

COPY r-packages-src.R /tmp/r-packages-src.R

# Install additional packages from source
RUN Rscript /tmp/r-packages-src.R && \
    rm -rf /tmp/downloaded_packages/ /tmp/*.rds

RUN R --no-echo -e 'cat(Sys.getenv("R_HOME"), Sys.getenv("R_LIBS_USER"),"\n");cat(.libPaths(),"\n"); print(installed.packages()[,c("Package", "Version")])'

# Change default R repo (used by renv)
COPY Rprofile.site /etc/R/Rprofile.site
COPY Rprofile.site /usr/local/lib/R/etc/Rprofile.site

# Installing sssd-tools (required for authentication)
RUN apt update && \
    apt-get -y clean all && \
    apt-get -y update && \
    # apt-get -y upgrade && \
    # apt-get -y dist-upgrade && \
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

ENV FELLES=/ssb/bruker/felles

# adding a custom bashrc with git branch in PS1
COPY default-bashrc /etc/skel/.bashrc

COPY check-git-config.bash /usr/local/bin/check-git-config.sh
RUN chmod +x /usr/local/bin/check-git-config.sh

# Install ssb-gitconfig.py script
RUN wget -O /usr/local/bin/ssb-gitconfig.py https://raw.githubusercontent.com/statisticsnorway/kvakk-git-tools/main/kvakk_git_tools/ssb_gitconfig.py
RUN chmod +x /usr/local/bin/ssb-gitconfig.py

# Appends ssh-rsa as the accepted algorithm to /etc/ssh/ssh_config
RUN printf "    PubkeyAcceptedAlgorithms +ssh-rsa\n    HostkeyAlgorithms +ssh-rsa" >> /etc/ssh/ssh_config

# Set Dapla environment variables used to identify the service.
ENV DAPLA_SERVICE=R_STUDIO
ENV DAPLA_REGION=ON_PREM

# Custom startup script which calls the original startup script /init at the end
COPY start.sh /start.sh
RUN chmod +x /start.sh

RUN /rocker_scripts/install_verse.sh

RUN /rocker_scripts/install_texlive.sh

# Use proxy for https connections, this must happen last
ENV https_proxy=http://proxy.ssb.no:3128
ENV no_proxy=nexus.ssb.no,git-adm.ssb.no,i.test.ssb.no,i.ssb.no,data.ssb.no,github.com,api.github.com,codeload.github.com,www.ssb.no


EXPOSE 8787

CMD ["/start.sh"]

# COPY scripts/bin/ /rocker_scripts/bin/
# COPY scripts/setup_R.sh /rocker_scripts/setup_R.sh
# RUN <<EOF
# if grep -q "1000" /etc/passwd; then
#     userdel --remove "$(id -un 1000)";
# fi
# /rocker_scripts/setup_R.sh
# EOF

# COPY scripts/install_tidyverse.sh /rocker_scripts/install_tidyverse.sh
# RUN /rocker_scripts/install_tidyverse.sh

# ENV S6_VERSION="v2.1.0.2"
# ENV RSTUDIO_VERSION="2024.12.1+563"
# ENV DEFAULT_USER="rstudio"

# COPY scripts/install_rstudio.sh /rocker_scripts/install_rstudio.sh
# COPY scripts/install_s6init.sh /rocker_scripts/install_s6init.sh
# COPY scripts/default_user.sh /rocker_scripts/default_user.sh
# COPY scripts/init_set_env.sh /rocker_scripts/init_set_env.sh
# COPY scripts/init_userconf.sh /rocker_scripts/init_userconf.sh
# COPY scripts/pam-helper.sh /rocker_scripts/pam-helper.sh
# RUN /rocker_scripts/install_rstudio.sh

# EXPOSE 8787
# CMD ["/init"]

# COPY scripts/install_pandoc.sh /rocker_scripts/install_pandoc.sh
# RUN /rocker_scripts/install_pandoc.sh

# COPY scripts/install_quarto.sh /rocker_scripts/install_quarto.sh
# RUN /rocker_scripts/install_quarto.sh

# ENV CTAN_REPO="https://www.texlive.info/tlnet-archive/2025/04/10/tlnet"
# ENV PATH="$PATH:/usr/local/texlive/bin/linux"

# COPY scripts/install_verse.sh /rocker_scripts/install_verse.sh
# COPY scripts/install_texlive.sh /rocker_scripts/install_texlive.sh
# RUN /rocker_scripts/install_verse.sh

# COPY scripts/install_geospatial.sh /rocker_scripts/install_geospatial.sh
# RUN /rocker_scripts/install_geospatial.sh

# COPY scripts /rocker_scripts