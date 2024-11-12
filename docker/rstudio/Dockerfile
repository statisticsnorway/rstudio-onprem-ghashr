FROM rocker/geospatial:4.4.1

USER root

ARG openjdk_version="19"
ARG libarrow_version="17.0.0"

RUN R --no-echo -e "cat(Sys.getenv('R_HOME'), Sys.getenv('R_LIBS_USER'),'\n');cat(.libPaths(),'\n'); print(installed.packages()[,c('Package', 'Version')])"

# Add Arrow repository and set up package pinning
RUN apt-get update -y \
    && apt-get -y upgrade \
    && apt-get -y dist-upgrade \
    && apt-get install -y --no-install-recommends "openjdk-${openjdk_version}-jdk-headless" ca-certificates-java \
    software-properties-common dirmngr build-essential wget curl libssl-dev libcurl4-openssl-dev libglpk-dev libgdal-dev libre2-dev \
    apt-utils libudunits2-dev cmake lsb-release gpg-agent libssh-dev libsodium-dev gfortran cargo libcairo2-dev zlib1g-dev \
    # Add the Apache Arrow repository
    && wget https://apache.jfrog.io/artifactory/arrow/ubuntu/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb \
    && apt install -y ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb \
    && apt update \
    # Set package pinning for Apache Arrow and dependencies to version 17.0.0
    && echo "Package: libarrow-dev libarrow-glib-dev libarrow-dataset-dev libarrow-dataset-glib-dev libarrow-acero-dev libarrow-flight-dev libarrow-flight-glib-dev libarrow-flight-sql-dev libarrow-flight-sql-glib-dev libgandiva-dev libgandiva-glib-dev libparquet-dev libparquet-glib-dev gir1.2-arrow-1.0 gir1.2-arrow-dataset-1.0 gir1.2-arrow-flight-1.0 gir1.2-arrow-flight-sql-1.0 gir1.2-gandiva-1.0 gir1.2-parquet-1.0\nPin: version 17.0.0-1\nPin-Priority: 1001" > /etc/apt/preferences.d/arrow-pinning \
    # Install Arrow and Parquet dependencies for version 17.0.0
    && apt-get install -y libarrow-dev=${libarrow_version}-1 libarrow-glib-dev=${libarrow_version}-1 libarrow-dataset-dev=${libarrow_version}-1 libarrow-dataset-glib-dev=${libarrow_version}-1 libarrow-acero-dev=${libarrow_version}-1 libarrow-flight-dev=${libarrow_version}-1 libarrow-flight-glib-dev=${libarrow_version}-1 libarrow-flight-sql-dev=${libarrow_version}-1 libarrow-flight-sql-glib-dev=${libarrow_version}-1 libgandiva-dev=${libarrow_version}-1 libgandiva-glib-dev=${libarrow_version}-1 libparquet-dev=${libarrow_version}-1 libparquet-glib-dev=${libarrow_version}-1 \
    
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

# Remaining setup commands
# ...

EXPOSE 8787

CMD ["/start.sh"]
