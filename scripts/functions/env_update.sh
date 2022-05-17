#!/usr/bin/env bash

function env_update () {
  # WIP ##
  local gdrive_id=$1

  for lang in "${!IPLANG[@]}"
  do
    cp --no-preserve=xattr ../files/env env # No preserve is macox with gnuutils fix.
    sed -i -e '/LANG/d' env
    sed -i -e '/GDRIVE_DRIVE_ID/d' env

    echo "LANG=$lang" >> env
    echo "GDRIVE_DRIVE_ID=$gdrive_id" >> env

    scp env stream@$host:/opt/stream-services/cloudobs/.env
    # Updating requiremets
    # ssh stream@$host "cd /opt/stream-services/cloudobs/ && git pull && pip3 install -r requirements.txt" > /dev/null 2>&1

    ssh stream@$host sudo systemctl restart common_service   > /dev/null 2>&1
    ssh stream@$host sudo systemctl restart instance_service > /dev/null 2>&1
    ssh stream@$host sudo systemctl restart gdrive_sync      > /dev/null 2>&1
    echo "[ $host ] Updated"
    rm env
  done
}
