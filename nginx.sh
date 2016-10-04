#!/bin/sh
echo "launching cron"
exec "/usr/sbin/cron" 
echo "Launching nginx"
exec "/usr/sbin/nginx"
