#!/bin/bash

sh ./gen-and-dep-keys.sh
sh ./install-controller.sh
sh ./install-worker.sh
sh ./register-keys.sh
