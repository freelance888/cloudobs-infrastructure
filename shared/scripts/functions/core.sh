#!/usr/bin/env bash

function env_update () {
  # WIP ##
  local gdrive_id=$1

  for lang in "${!IPLANG[@]}"
  do
    cp --no-preserve=xattr ../files/env env # No preserve is macox with gnuutils fix.
    sed -i -e '/LANG/d' env
    sed -i -e '/GDRIVE_DRIVE_ID/d' env

    echo "LANG=$lang" >> env
    echo "GDRIVE_DRIVE_ID=$gdrive_id" >> env

    scp env stream@$host:/opt/stream-services/cloudobs/.env
    # Updating requiremets
    # ssh stream@$host "cd /opt/stream-services/cloudobs/ && git pull && pip3 install -r requirements.txt" > /dev/null 2>&1

    # ssh stream@$host sudo systemctl restart common_service   > /dev/null 2>&1
    ssh stream@$host sudo systemctl restart instance_service > /dev/null 2>&1
    ssh stream@$host sudo systemctl restart gdrive_sync      > /dev/null 2>&1
    echo "[ $host ] Updated"
    rm env
  done
}

function get_status () {
  for lang in "${!IPLANG[@]}"
  do
    echo " "
    echo " $lang | [ ${IPLANG[$lang]} ] ================================"
    ssh stream@${IPLANG[$lang]} "systemctl status instance_service && systemctl status gdrive_sync"
  done
}

function upload_files () {
  for lang in "${!IPLANG[@]}"
  do
    echo " * Sending files to [ $lang ] | ${IPLANG[$lang]}"
    ssh-keygen -R "${IPLANG[$lang]}" > /dev/null 2>&1 # Removes host from known_hosts to avoid long annoying message about changed keys.

    # scp ../files/services/* root@${IPLANG[$lang]}:/lib/systemd/system/ > /dev/null 2>&1 &
    cd ..
    COPYFILE_DISABLE=1 tar -cvf files.tar files > /dev/null 2>&1
    cd - > /dev/null 2>&1
    scp provision.sh ../files.tar sa.json stream@${IPLANG[$lang]}:~ > /dev/null 2>&1

  done
  rm -rf ../files.tar
}

function provision () {
  for lang in "${!IPLANG[@]}"
  do
    echo " * Provisionion [ $lang ] | ${IPLANG[$lang]}"
    # ssh stream@${IPLANG[$lang]} nohup bash ./provision.sh $lang &
    sleep 2
    ssh stream@${IPLANG[$lang]} nohup bash ./provision.sh $lang > /dev/null 2>&1 &
  done
  exit
}

TODAY_DATE="$(date +'%d.%m.%Y')"
mkdir -p recordings/$TODAY_DATE

function start_rec () {
  for lang in "${!IPLANG[@]}"
  do
    echo " * Starting recording for [ $lang ] | ${IPLANG[$lang]}"
    ssh stream@${IPLANG[$lang]} "nohup ffmpeg -f pulse -i default ${lang}.wav > /dev/null 2>&1 &"
  done
}

function stop_rec () {
  for lang in "${!IPLANG[@]}"
  do
    echo " * Stopping recording for [ $lang ] | ${IPLANG[$lang]}"
    ssh stream@${IPLANG[$lang]} "pkill ffmpeg --signal 15"
  done
}

function get_rec () {
  echo -e "\n!!! Preliminary wiping content of [ recordings/$TODAY_DATE ] directory.\n"
  rm -rf recordings/$TODAY_DATE/*

  for lang in "${!IPLANG[@]}"
  do
    echo " * Downloading recording file for [ $lang ] | ${IPLANG[$lang]}"
    scp stream@${IPLANG[$lang]}:${lang}.wav recordings/$TODAY_DATE &
  done
}

function del_rec () {
  for lang in "${!IPLANG[@]}"
  do
    echo " * Deleting remote recording file for [ $lang ] | ${IPLANG[$lang]}"
    ssh stream@${IPLANG[$lang]} "rm -rf ${lang}.wav"
  done
}

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
