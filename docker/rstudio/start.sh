#!/bin/bash

echo "Running custom startup script"

# sourcing stamme_variabel in startup they are available to all users in RStudio
source /etc/profile.d/stamme_variabel

export STATBANK_BASE_URL=$STATBANK_BASE_URL
export STATBANK_ENCRYPT_URL=$STATBANK_ENCRYPT_URL

# updating CA-certificate before starting RStudio so users can access github
update-ca-certificates

# start cron
service cron start

/bin/execlineb -pS0 /init