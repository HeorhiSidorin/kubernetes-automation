#!/bin/bash

source ./env

echo $MASTER_HOST
echo $K8S_SERVICE_IP
echo $worker_count
echo ${worker_ips[0]}
echo ${worker_ips[1]}

echo ${worker_fqdns[0]}
echo ${worker_fqdns[1]}

echo $ETCD_ENDPOINTS

variable="dwe"

sample=slslslsllss$variable

echo $sample
