#!/bin/bash

sh ./generate-certs.sh
sh ./deploy-master-keys.sh
sh ./deploy-workers-keys.sh
