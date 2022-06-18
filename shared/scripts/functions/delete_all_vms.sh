#!/usr/bin/env bash

function delete_all_vms () {
  local instances="$(hcloud server list -o columns=id -o noheader)"
  echo "DELETING ALL INSTANCES!!! To abort press Ctrl+C. Any key to continue."
  echo "ARE YOU SURE?"
  for i in $instances; do
    echo $i
  done
  read answer
  echo " ABSOLUTELY SURE ??"
  read answer
  for i in $instances; do
    hcloud server delete $i
  done
}
