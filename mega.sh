#!/bin/bash

source ./env

bash ./gen-and-dep-keys.sh
bash ./install-controller.sh
bash ./install-worker.sh
bash ./register-keys.sh
