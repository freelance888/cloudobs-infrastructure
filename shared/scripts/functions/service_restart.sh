#!/usr/bin/env bash

function service_restart () {
  for lang in "${!IPLANG[@]}"
  do
    echo " * Restarting services for [ $lang ] | ${IPLANG[$lang]}"
    ssh stream@${IPLANG[$lang]} sudo systemctl restart instance_service > /dev/null 2>&1
    ssh stream@${IPLANG[$lang]} sudo systemctl restart gdrive_sync      > /dev/null 2>&1

    ssh stream@${IPLANG[$lang]} 'kill -15 $(pgrep -f ts3client_linux_amd64) && pulseaudio --kill' #> /dev/null 2>&1
    ssh stream@${IPLANG[$lang]} 'pulseaudio --kill' #> /dev/null 2>&1
    sleep 6

    ssh stream@${IPLANG[$lang]} "nohup pulseaudio -D &" > /dev/null 2>&1
    sleep 2
    ssh stream@${IPLANG[$lang]} "cd ts && DISPLAY=:1 ./ts3client_runscript.sh \"ts3server://ts.it-planeta.com?port=10335&channel=Translation/${lang}&nickname=${lang}_StreamListener\" &" > /dev/null 2>&1 &
  done
}
