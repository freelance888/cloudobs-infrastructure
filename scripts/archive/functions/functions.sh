#!/usr/bin/env bash

function send_files () {
  local host=$1
  local lang=$2

  ssh-keygen -R "$host" > /dev/null 2>&1 # Removes host from known_hosts to avoid long annoying message about changed keys.

  scp ../files/services/*   \
      root@$host:/lib/systemd/system/ > /dev/null 2>&1

  scp provision.sh          \
    ../files/env            \
    ../files/obs_config.tar \
    ../files/ts_config.tar  \
    ../files/ts_client.tar  \
    stream@$host:~ > /dev/null 2>&1
}

function setup () {
  local host=$1
  ssh stream@$host nohup bash ./provision.sh $lang # > /dev/null 2>&1
}

function service_restart () {
  local host=$1

  ssh stream@$host sudo systemctl restart common_service   > /dev/null 2>&1
  ssh stream@$host sudo systemctl restart instance_service > /dev/null 2>&1
  ssh stream@$host sudo systemctl restart gdrive_sync      > /dev/null 2>&1
}

function env_update () {
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

function get_status () {
  local host=$1

  ssh stream@$host "systemctl status common_service && systemctl status instance_service && systemctl status gdrive_sync"

  # ssh stream@$host systemctl status common_service
  # ssh stream@$host systemctl status instance_service
  # ssh stream@$host systemctl status gdrive_sync

}
