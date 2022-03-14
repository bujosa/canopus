#!/usr/bin/env bash

## Launch containers
 
# portainer
docker run -d --name portainer -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce

# alea docker build 
git clone https://github.com/pjmolina/random-app.git
cd random-app
docker build -t alea .
docker run -d --name alea0 -p 8001:5000 -e CONSUL_BIND_INTERFACE=eth0 alea
