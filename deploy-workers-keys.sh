#!/bin/bash

source ./env

for (( i=0; i<$worker_count; i++ ))
do
ssh -o "StrictHostKeyChecking no" -t -t core@${worker_ips[i]} << EOF
sudo rm -rf /etc/kubernetes/ssl
sudo mkdir -p /etc/kubernetes/ssl
exit
EOF

scp ./certs/ca.pem core@${worker_ips[i]}:~/
scp ./certs/${worker_fqdns[i]}-worker.pem core@${worker_ips[i]}:~/
scp ./certs/${worker_fqdns[i]}-worker-key.pem core@${worker_ips[i]}:~/

ssh -t -t core@${worker_ips[i]} << EOF
sudo mv ${worker_fqdns[i]}-worker.pem /etc/kubernetes/ssl/worker.pem
sudo mv ${worker_fqdns[i]}-worker-key.pem /etc/kubernetes/ssl/worker-key.pem
sudo mv ca.pem /etc/kubernetes/ssl/
sudo chmod 600 /etc/kubernetes/ssl/*-key.pem
sudo chown root:root /etc/kubernetes/ssl/*-key.pem
exit
EOF

done
