#!/bin/bash

set -e

docker pull debian:stretch-slim

docker build -t turtl-certbox .


