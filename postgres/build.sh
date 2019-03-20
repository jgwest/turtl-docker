#!/bin/bash

set -e

docker pull postgres:11

docker build -t turtl-postgres .

