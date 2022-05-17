#!/usr/bin/env bash

source ip.list # Sources Lang - IP array

source functions/env_update.sh
source functions/get_status.sh
source functions/provision.sh
source functions/send_files.sh
source functions/service_restart.sh

# Check if no args supplied
if [ -z $* ]; then
  echo "No options found!"
  exit 1
fi

while [ $# -gt 0 ] ; do
  case $1 in
    # -e | --envupdate)       env_update ;; # WIP
    -p | --provision)       provision ;;
    # -r | --restartservices) service_restart ;; # WIP
    -s | --status)          get_status ;;
    -u | --uploadfiles)     send_files ;;
  esac
  shift
done

# sendfiles provision launchapps envupdate restartservices getstatus
