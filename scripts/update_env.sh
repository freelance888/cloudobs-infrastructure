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

# update "0.0.0.0" Ara 000000000000000000000000000000000
# update "0.0.0.0" Ces 000000000000000000000000000000000
# update "0.0.0.0" Deu 000000000000000000000000000000000
# update "0.0.0.0" Eng 000000000000000000000000000000000
# update "0.0.0.0" Fra 000000000000000000000000000000000
# update "0.0.0.0" Ita 000000000000000000000000000000000
# update "0.0.0.0" Pol 000000000000000000000000000000000
# update "0.0.0.0" Rus 000000000000000000000000000000000
# update "0.0.0.0" Spa 000000000000000000000000000000000
# update "0.0.0.0" Ukr 000000000000000000000000000000000
