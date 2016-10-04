#!/bin/bash

source ./env

echo $master_count
echo $master_ips
echo "lol"

for (( i=0; i<$master_count; i++ ))
do
  scp ./env core@${master_ips[i]}:~/
done

for (( i=0; i<$master_count; i++ ))
do
  ssh core@${master_ips[i]} 'sudo bash -s' < ./controller-install.sh &
done

wait
