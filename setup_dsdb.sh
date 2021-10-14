#!/bin/sh

set -ev

runuser -u mysql -- mysql -e "\
CREATE USER 'dsdb'@'%' IDENTIFIED BY 'dsdb';
CREATE DATABASE dsdb;
CREATE TABLE dsdb.Usuario (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL
);
GRANT ALL PRIVILEGES ON dsdb.* TO 'dsdb'@'%';"
