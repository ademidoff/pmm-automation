#!/bin/bash -e

docker rm -vf mysql-group1 mysql-group2 mysql-group3
rm -rf "$HOME/mysql-group-data"
