#!/bin/bash

# Move to the directory of the script ------
export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

set -e

cd server
git fetch

# commit 9c529f2d3b2a673e092785bf23e3a4839028dfa1
# Author: Andrew Danger Lyon <orthecreedence@gmail.com>
# Date:   Thu Dec 13 21:57:51 2018 -0800
git checkout 9c529f2d3b2a673e092785bf23e3a4839028dfa1

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
#./update.sh
cd ..

cd certbot
./build.sh
cd ..


cd mail
./build.sh
cd ..

cd tarsnap
./build.sh
cd ..

