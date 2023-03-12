#!/usr/bin/env bash

echo "Digital Ocean functions loaded."
function create_vm () {
  local instances_count=$1
  local count=1

  while [ $count -le $instances_count ]
  do
    echo " * Generating vm number [ $count ] "

    doctl compute droplet create               \
      --image ubuntu-22-04-x64                 \
      --size s-1vcpu-1gb                       \
      --region fra1                            \
      --ssh-keys "b2:66:15:b3:d1:2f:8c:56:5d:fb:17:5b:91:16:e2:a5"                 \
      --user-data-file=../files/userdata.yaml  \
      --wait                                   \
      do-streaming-node-$count &

    count=$(( $count + 1 ))
  done
  exit
}

function delete_all_vms () {
  for droplet_id in $(doctl compute droplet list --format "ID" --no-header); do doctl compute droplet delete --force $droplet_id; done
  exit
}

function get_ip () {
  doctl compute droplet list --no-header --format "PublicIPv4"
  exit
}
