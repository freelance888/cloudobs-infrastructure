#!/usr/bin/env bash

function create_vm () {
  local instances_count=$1
  local count=1

  while [ $count -le $instances_count ]
  do
    echo " * Generating vm number [ $count ] "
    hcloud server create                           \
      --image=ubuntu-22.04                         \
      --type=cpx51                                 \
      --location=ash                              \
      --ssh-key=service_automation               \
      --user-data-from-file=../files/userdata.yaml \
      --name=streaming-node-$count &
    count=$(( $count + 1 ))
  done
}
