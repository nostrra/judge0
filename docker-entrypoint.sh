#!/bin/bash
sudo chmod -R 777 /var/run
sudo chmod gu+rw /var/run
sudo chmod -R 777 /api/tmp
sudo chmod gu+rw /api/tmp
sudo chmod gu+s /usr/sbin/cron
cron
exec "$@"