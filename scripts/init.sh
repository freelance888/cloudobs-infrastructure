#!/usr/bin/env bash

# Iteratively send bash scripts to host and execute
# echo " * Sleeping for 3 minutes, awaiting VM to get ready "
# sleep 180 # Needed to be sure that programs is ready to launch after init hetzner script that installs all apps.

# USAGE: Add your env file, tarred archives of obs and teamspeak settings with ts client and run
# $ sleep 180 && ./init.sh

echo " ============= [ START ] ============="

function setup () {
  local host=$1
  local lang=$2

  ssh-keygen -R "$host" > /dev/null 2>&1 # Removes host from known_hosts to avoid long annoying message about changed keys.
  echo " * Processing | $host"

  # Copy files and start provisioning script
  scp ../files/services/*   \
      root@$host:/lib/systemd/system/

  scp provision.sh          \
    ../files/env            \
    ../files/obs_config.tar \
    ../files/ts_config.tar  \
    ../files/ts_client.tar  \
    stream@$host:~

  # Executing provision.sh script.
  ssh stream@$host nohup bash ./provision.sh $lang #> /dev/null 2>&1
}

# HOSTS SECITON

# setup "0.0.0.0" Ara &
# setup "0.0.0.0" Ces &
# setup "0.0.0.0" Deu &
# setup "0.0.0.0" Eng &
# setup "0.0.0.0" Fra &
# setup "0.0.0.0" Ita &
# setup "0.0.0.0" Pol &
# setup "0.0.0.0" Rus &
# setup "0.0.0.0" Spa &
# setup "0.0.0.0" Ukr &

echo " ============= [ DONE ] ============="
