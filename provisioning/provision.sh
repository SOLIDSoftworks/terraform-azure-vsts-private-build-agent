#!/bin/bash
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install libunwind8 libcurl3 git docker.io
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get -y install nodejs

echo 'Getting agent'
sudo curl -fkSL -o ./vsts-agent-ubuntu.tar.gz https://github.com/Microsoft/vsts-agent/releases/download/v2.116.1/vsts-agent-ubuntu.16.04-x64-2.116.1.tar.gz
echo 'Extracting agent'
sudo tar -zxvf ./vsts-agent-ubuntu.tar.gz
