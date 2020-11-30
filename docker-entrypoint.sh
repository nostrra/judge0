#!/bin/bash
sudo touch /api/log/development.log
sudo chmod 0664 /api/log/development.log
sudo chmod -R 777 /api/scripts
sudo chmod -R gu+rw /api/scripts
sudo chmod -R 777 /api/log
sudo chmod -R gu+rw /api/log
sudo chmod -R 777 /var/run
sudo chmod -R gu+rw /var/run
sudo chmod -R 777 /api/tmp
sudo chmod -R gu+rw /api/tmp
sudo chmod -R gu+s /usr/sbin/cron
cron
exec "$@"