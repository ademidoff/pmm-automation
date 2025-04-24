#!/bin/bash -e

docker stop mysql-group1 && docker rm -v mysql-group1
docker stop mysql-group2 && docker rm -v mysql-group2
docker stop mysql-group3 && docker rm -v mysql-group3

rm -rf ~/mysql-group-data
