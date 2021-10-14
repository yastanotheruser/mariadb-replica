#!/bin/sh

set -ev

export DEBIAN_FRONTEND=noninteractive
apt-get -qq purge --autoremove mariadb-server
rm -rf /var/lib/mysql /etc/mysql /run/mysqld
