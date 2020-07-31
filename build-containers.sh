#!/bin/bash

# Move to the directory of the script ------
export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

set -e

cd server
git fetch

#Merge: 8d4764f c397ecd
#Author: andrew lyon <orthecreedence@gmail.com>
#Date:   Tue Nov 5 14:48:45 2019 -0800
git checkout 4faa272e8a274582327ef3f2dcb18caf2124eeff


docker build -t turtl-image-git .
cd ..

cd turtl-server
./build.sh
cd ..

cd nginx
./build.sh
cd ..

cd postgres
./build.sh
cd ..

cd certbot
./build.sh
cd ..


cd mail
./build.sh
cd ..

cd inlets
./build.sh
cd ..

cd tarsnap
./build.sh
cd ..

