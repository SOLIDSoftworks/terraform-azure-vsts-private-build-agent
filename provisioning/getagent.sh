echo 'Getting agent'
sudo curl -fkSL -o ./vsts-agent-ubuntu.tar.gz https://github.com/Microsoft/vsts-agent/releases/download/v2.116.1/vsts-agent-ubuntu.16.04-x64-2.116.1.tar.gz
echo 'Extracting agent'
sudo tar -zxvf ./vsts-agent-ubuntu.tar.gz