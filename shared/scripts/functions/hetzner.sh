#!/usr/bin/env bash

echo "Hetzner functions loaded."
function create_vm () {
  local instances_count=$1
  local count=1

  while [ $count -le $instances_count ]
  do
    echo " * Generating vm number [ $count ] "

    hcloud server create                           \
      --image=ubuntu-22.04                         \
      --type=cpx51                                 \
      --location=nbg1                              \
      --ssh-key=service_automation                 \
      --user-data-from-file=../files/userdata.yaml \
      --name=hetzner-streaming-node-$count &

    count=$(( $count + 1 ))
  done
  exit
}

function delete_all_vms () {
  local instances="$(hcloud server list -o columns=id -o noheader)"
  echo "DELETING ALL INSTANCES!!! To abort press Ctrl+C. Any key to continue."
  for i in $instances; do
    echo $i
  done
  for i in $instances; do
    hcloud server delete $i
  done
  exit
}

function get_ip () {
  hcloud server list -o columns=ipv4 -o noheader | sort
  exit
}
