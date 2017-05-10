echo 'Configuring agent'
./config.sh --acceptteeeula --pool $1 --agent $2 --url https://$3.visualstudio.com/ --work _work --auth PAT --token $4 --runasservice --replace
echo 'Installing agent service'
sudo ./svc.sh install
echo 'Starting agent service'
sudo ./svc.sh start