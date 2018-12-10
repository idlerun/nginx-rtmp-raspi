#!/bin/bash -e
cd $(dirname $0)
docker build -t nginx-rtmp-raspi .
