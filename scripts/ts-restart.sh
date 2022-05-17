#!/usr/bin/env bash

# Script for target language restart
# Usage: ./ts-restart.sh <LANG CODE>.
# Example ./ts-restart.sh Eng


source ip.list # Sources Lang - IP array
language=$1

for lang in "${!IPLANG[@]}"
do
  # Check if $lang exist in array - then action
  # [ "${IPLANG[$lang]}" ] && echo "exists" # Short ver, but not adapted.

  if [ "${IPLANG[$language]}" ]; then
    echo "[ $language ] is exist in array. Restarting."
    # ssh stream@${IPLANG[$lang]} 'kill -15 $(pgrep -f ts3client_linux_amd64) && pulseaudio --kill' #> /dev/null 2>&1
    # ssh stream@${IPLANG[$lang]} 'pulseaudio --kill' #> /dev/null 2>&1
    # sleep 6

    # ssh stream@${IPLANG[$lang]} "nohup pulseaudio -D &" > /dev/null 2>&1
    # sleep 2
    # ssh stream@${IPLANG[$lang]} "cd ts && DISPLAY=:1 ./ts3client_runscript.sh \"ts3server://ts.it-planeta.com?port=10335&channel=Translation/${lang}&nickname=${lang}_StreamListener\" &" > /dev/null 2>&1

    # ssh stream@${iplang[$lang]} "sudo mv /usr/lib/systemd/system/stream/* /usr/lib/systemd/system" > /dev/null 2>&1

    # ssh stream@${iplang[$lang]} "sudo systemctl enable common_service && sudo systemctl enable instance_service && sudo systemctl enable gdrive_sync && sudo systemctl start common_service && sudo systemctl start instance_service && sudo systemctl start gdrive_sync"
  else
    echo "The [ $lang ] does not exist in array. Exitting."
    exit
  fi
done
