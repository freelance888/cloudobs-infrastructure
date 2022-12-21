#!/usr/bin/env bash
REC_FILE_NAME="_stream_rec"
mkdir -p recordings

function start_rec () {
  for lang in "${!IPLANG[@]}"
  do
    echo " * Starting recording for [ $lang ] | ${IPLANG[$lang]}"
    ssh stream@${IPLANG[$lang]} "ffmpeg -f pulse -i default ${IPLANG[$lang]}${REC_FILE_NAME}.wav > /dev/null 2>&1"
  done
}

function stop_rec () {
  for lang in "${!IPLANG[@]}"
  do
    echo " * Starting recording for [ $lang ] | ${IPLANG[$lang]}"
    ssh stream@${IPLANG[$lang]} "pkill ffmpeg -s 15"
  done
}

function get_rec () {
  for lang in "${!IPLANG[@]}"
  do
    echo " * Starting recording for [ $lang ] | ${IPLANG[$lang]}"
    scp stream@${IPLANG[$lang]}:${IPLANG[$lang]}${REC_FILE_NAME}.wav recordings/${IPLANG[$lang]}${REC_FILE_NAME}.wav
  done
}
