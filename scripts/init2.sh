#!/usr/bin/env bash

# Iteratively send bash scripts to host and execute
# echo " * Sleeping for 3 minutes, awaiting VM to get ready "
# sleep 180 # Needed to be sure that programs is ready to launch after init hetzner script that installs all apps.

# USAGE: Add your env file, tarred archives of obs and teamspeak settings with ts client and run

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

for ip_lang_string in $(cat ip-lang.list); do
  #parse line
  ip=$(echo $ip_lang_string   | awk '{print $1}')
  lang=$(echo $ip_lang_string | awk '{print $2}')
  echo -n "\n$ip $lang\n"
  # setup "$ip" $lang &
done
