#!/bin/bash

source ./env

scp ./env core@$MASTER_HOST:~/
ssh core@$MASTER_HOST 'sudo bash -s' < ./controller-install.sh
