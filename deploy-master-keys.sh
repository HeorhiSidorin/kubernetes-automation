#!/bin/bash

source ./env

for (( i=0; i<$master_count; i++ ))
do
ssh -o "StrictHostKeyChecking no" -t -t core@${master_ips[i]} << EOF
sudo rm -rf /etc/kubernetes/ssl
sudo mkdir -p /etc/kubernetes/ssl
exit
EOF

scp ./certs/ca.pem core@${master_ips[i]}:~/
scp ./certs/${master_fqdns[i]}-apiserver.pem core@${master_ips[i]}:~/
scp ./certs/${master_fqdns[i]}-apiserver-key.pem core@${master_ips[i]}:~/

ssh -t -t core@${master_ips[i]} << EOF
sudo mv ${master_fqdns[i]}-apiserver.pem /etc/kubernetes/ssl/apiserver.pem
sudo mv ${master_fqdns[i]}-apiserver-key.pem /etc/kubernetes/ssl/apiserver-key.pem
sudo mv ca.pem /etc/kubernetes/ssl/
sudo chmod 600 /etc/kubernetes/ssl/*-key.pem
sudo chown root:root /etc/kubernetes/ssl/*-key.pem
exit
EOF

done
