#!/usr/bin/env bash

function update () {
  local host=$1
  local lang=$2
  local gdrive_id=$3

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
}

# HOSTS SECITON
source ip.list # Sources Lang - IP array

# Send files
for lang in "${!IPLANG[@]}"
do
  echo " * Updating env file for [ $lang ] | ${IPLANG[$lang]}"
  update "${IPLANG[$lang]}" $lang $gdrive_id & > /dev/null 2>&1
done

echo " * ENV update is complete."
