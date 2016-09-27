#!/bin/bash

source ./env

for (( i=0; i<$worker_count; i++ ))
do
  scp ./env core@${worker_ips[i]}:~/
  ssh core@${worker_ips[i]} 'sudo bash -s' < ./worker-install.sh
done
