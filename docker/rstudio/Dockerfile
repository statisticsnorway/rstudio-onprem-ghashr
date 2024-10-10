FROM rocker/r2u:jammy

USER root

RUN R --no-echo -e "cat(Sys.getenv('R_HOME'), Sys.getenv('R_LIBS_USER'));print(.libPaths()); print(installed.packages())"

#RUN /rocker_scripts/install_rstudio.sh
#RUN ./scripts/install_rstudio.sh
RUN wget --no-verbose https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2023.03.0-386-amd64.deb \
        && apt-get update \
        && apt-get install -y --no-install-recommends ./rstudio-server-2023.03.0-386-amd64.deb

# I wasn't sure what the password is, so setting one as we are logging as root by default on this docker
RUN echo "docker:pass" | chpasswd
RUN rstudio-server start

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
