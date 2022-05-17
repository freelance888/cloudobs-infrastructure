#!/usr/bin/env bash

host=$1
lang=$2
ssh stream@$host 'kill -15 $(pgrep -f ts3client_linux_amd64) && pulseaudio --kill' #> /dev/null 2>&1
ssh stream@$host 'pulseaudio --kill' #> /dev/null 2>&1
sleep 6

ssh stream@$host "nohup pulseaudio -D &" > /dev/null 2>&1
sleep 2
ssh stream@$host "cd ts && DISPLAY=:1 ./ts3client_runscript.sh \"ts3server://ts.it-planeta.com?port=10335&channel=Translation/${lang}&nickname=${lang}_StreamListener\" &" > /dev/null 2>&1

# ssh stream@$host "sudo mv /usr/lib/systemd/system/stream/* /usr/lib/systemd/system" > /dev/null 2>&1

# ssh stream@$host "sudo systemctl enable common_service && sudo systemctl enable instance_service && sudo systemctl enable gdrive_sync && sudo systemctl start common_service && sudo systemctl start instance_service && sudo systemctl start gdrive_sync"
