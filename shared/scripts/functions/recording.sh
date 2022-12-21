#!/usr/bin/env bash
TODAY_DATE="$(date +'%d.%m.%Y')"
mkdir -p recordings/$TODAY_DATE

function start_rec () {
  for lang in "${!IPLANG[@]}"
  do
    echo " * Starting recording for [ $lang ] | ${IPLANG[$lang]}"
    ssh stream@${IPLANG[$lang]} "nohup ffmpeg -f pulse -i default ${lang}.wav & > /dev/null 2>&1"
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
  for lang in "${!IPLANG[@]}"
  do
    echo " * Downloading recording file for [ $lang ] | ${IPLANG[$lang]}"
    scp stream@${IPLANG[$lang]}:${lang}.wav recordings/$TODAY_DATE
  done
}

function del_rec () {
  for lang in "${!IPLANG[@]}"
  do
    echo " * Deleting recording file for [ $lang ] | ${IPLANG[$lang]}"
    ssh stream@${IPLANG[$lang]} "rm -rf ${lang}.wav"
  done
}
