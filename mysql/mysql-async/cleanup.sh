#!/bin/bash

docker rm -vf mysql-async1 mysql-async2 mysql-async3
rm -rf "$HOME/mysql-async-data"
