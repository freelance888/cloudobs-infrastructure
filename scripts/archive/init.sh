#!/usr/bin/env bash

# USAGE: Add your env file, tarred archives of obs and teamspeak settings with ts client and run

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

# HOSTS SECITON
source ip.list # Sources Lang - IP array

# Send files
for lang in "${!IPLANG[@]}"
do
  echo " * Sending files to [ $lang ] | ${IPLANG[$lang]}"
  send_files "${IPLANG[$lang]}" & > /dev/null 2>&1
done

echo " "
echo " * Waiting 80 seconds for all apps is installed."
echo " "
sleep 80

# Execute final provision script
for lang in "${!IPLANG[@]}"
do
  echo " * Launching apps on [ $lang ] | ${IPLANG[$lang]}"
  setup "${IPLANG[$lang]}" $lang &
  echo " | ----------------------------------------------------------- "
  echo " | ----------------------------------------------------------- "
  echo " | ----------------------------------------------------------- "
  echo " | ----------------------------------------------------------- "
done

echo " "
echo "Provisioning is complete."
