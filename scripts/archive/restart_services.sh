#!/usr/bin/env bash

function service_restart () {
  local host=$1

  ssh stream@$host sudo systemctl restart common_service   > /dev/null 2>&1
  ssh stream@$host sudo systemctl restart instance_service > /dev/null 2>&1
  ssh stream@$host sudo systemctl restart gdrive_sync      > /dev/null 2>&1
}

# HOSTS SECITON
source ip.list # Sources Lang - IP array

# Send files
for lang in "${!IPLANG[@]}"
do
  echo " * Restarting services for [ $lang ] | ${IPLANG[$lang]}"
  service_restart "${IPLANG[$lang]}" &
done

echo " * Restart is complete."
