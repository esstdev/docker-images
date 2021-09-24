#!/usr/bin/env bash

set -e
printenv | sed 's/^\([a-zA-Z0-9_]*\)=\(.*\)$/export \1="\2"/g' > /.env
/etc/init.d/cron start
apache2-foreground