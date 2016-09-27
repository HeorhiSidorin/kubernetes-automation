#!/bin/bash

source ./env

ssh -t -t core@$MASTER_HOST << EOF
sudo rm -rf /etc/kubernetes/ssl
sudo mkdir -p /etc/kubernetes/ssl
exit
EOF

scp ./certs/ca.pem core@$MASTER_HOST:~/
scp ./certs/apiserver.pem core@$MASTER_HOST:~/
scp ./certs/apiserver-key.pem core@$MASTER_HOST:~/

ssh -t -t core@$MASTER_HOST << EOF
sudo mv *.pem /etc/kubernetes/ssl
sudo chmod 600 /etc/kubernetes/ssl/*-key.pem
sudo chown root:root /etc/kubernetes/ssl/*-key.pem
exit
EOF
