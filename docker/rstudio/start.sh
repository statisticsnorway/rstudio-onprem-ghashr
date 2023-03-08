#!/bin/bash

echo "Running custom startup script"

# sourcing stamme_variabel in startup they are available to all users in RStudio
source /etc/profile.d/stamme_variabel

# updating CA-certificate before starting RStudio so users can access github
update-ca-certificates

# start cron
service cron start

/bin/execlineb -pS0 /init