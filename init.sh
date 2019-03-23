#!/bin/bash

export SCRIPT_ROOT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_ROOT

# -------------------------------

set -e

mkdir -p data/postgres
sudo chown -R www-data:www-data data/postgres

mkdir -p data/turtl

mkdir -p data/nginx-tmp/conf.d
mkdir -p data/nginx-tmp/cache
mkdir -p data/nginx-tmp/var-run
sudo chown -R www-data:www-data data/nginx-tmp


git clone https://github.com/turtl/server



