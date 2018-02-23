#!/bin/bash

echo "Bringing up fresh CaaSP instance"

export CAASP_MASTER_RAM=4192
export CAASP_WORKER_RAM=16384
export CAASP_WORKER_CPU=4
export WORKERS=2

pushd automation
./caasp-devenv -b -m 1 -w ${WORKERS} -i channel://release -B
popd
