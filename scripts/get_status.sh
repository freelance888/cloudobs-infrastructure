#!/usr/bin/env bash

function get_status () {
  local host=$1

  ssh stream@$host "systemctl status common_service && systemctl status instance_service && systemctl status gdrive_sync"

  # ssh stream@$host systemctl status common_service
  # ssh stream@$host systemctl status instance_service
  # ssh stream@$host systemctl status gdrive_sync

}

# HOSTS SECITON
source ip.list # Sources Lang - IP array

# Send files
for lang in "${!IPLANG[@]}"
do
  echo " * Getting status for services of the [ $lang ] | ${IPLANG[$lang]}"
  get_status "${IPLANG[$lang]}" &
  echo " | ----------------------------------------------------------- "
  echo " | ----------------------------------------------------------- "
done

echo " * Status request is complete."
