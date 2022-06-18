#!/usr/bin/env bash

function get_status () {
  for lang in "${!IPLANG[@]}"
  do
    echo " "
    echo " $lang | [ ${IPLANG[$lang]} ] ================================"
    ssh stream@${IPLANG[$lang]} "systemctl status instance_service && systemctl status gdrive_sync"
  done
}
