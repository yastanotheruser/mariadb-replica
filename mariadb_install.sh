#!/bin/sh

[ $# != 2 ] && {
    echo "usage: $0 <server_id> <master_id>" >&2
    exit 1
}

set -ev

apt-get -qq update >/dev/null 2>&1
apt-get -qq install mariadb-server >/dev/null 2>&1

REPLICATION_CONFIG=/etc/mysql/mariadb.conf.d/60-ds-replication.cnf
cat >$REPLICATION_CONFIG <<EOF
[mysqld]
bind_address		= 0.0.0.0
log_bin			= /var/log/mysql/mysql-bin.log
relay_log		= /var/log/mysql/relay-bin.log
log_slave_updates	= 1
server_id		= $1
log_basename		= master$1
binlog_format		= mixed
EOF

systemctl restart mariadb.service

runuser -u mysql -- mysql -e "\
CREATE USER 'replication_user$1'@'%' IDENTIFIED BY 'replication_user$1';
GRANT REPLICATION SLAVE ON *.* TO 'replication_user$1'@'%';
FLUSH PRIVILEGES;
CHANGE MASTER TO
    MASTER_HOST = 'mariadb$2',
    MASTER_USER = 'replication_user$2',
    MASTER_PASSWORD = 'replication_user$2',
    MASTER_CONNECT_RETRY = 8;
RESET SLAVE;
START SLAVE;"
