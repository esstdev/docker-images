#!/bin/bash

printenv | sed 's/^\([a-zA-Z0-9_]*\)=\(.*\)$/export \1="\2"/g' > /.env

crontab -u noroot /var/spool/cron/crontabs/noroot
/etc/init.d/cron start

apache2-foreground