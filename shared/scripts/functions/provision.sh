#!/usr/bin/env bash

function provision () {
  for lang in "${!IPLANG[@]}"
  do
    echo " * Provisionion [ $lang ] | ${IPLANG[$lang]}"
    # ssh stream@${IPLANG[$lang]} nohup bash ./provision.sh $lang &
    sleep 2
    ssh stream@${IPLANG[$lang]} nohup bash ./provision.sh $lang > /dev/null 2>&1 &
  done
}
