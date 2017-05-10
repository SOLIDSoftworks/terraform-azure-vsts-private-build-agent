#!/bin/bash
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install libunwind8 libcurl3 git docker.io
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get -y install nodejs