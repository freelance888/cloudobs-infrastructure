#!/usr/bin/env bash

function upload_files () {
  for lang in "${!IPLANG[@]}"
  do
    echo " * Sending files to [ $lang ] | ${IPLANG[$lang]}"
    ssh-keygen -R "${IPLANG[$lang]}" > /dev/null 2>&1 # Removes host from known_hosts to avoid long annoying message about changed keys.

    # scp ../files/services/* root@${IPLANG[$lang]}:/lib/systemd/system/ > /dev/null 2>&1 &
    cd ..
    COPYFILE_DISABLE=1 tar -cvf files.tar files > /dev/null 2>&1
    cd - > /dev/null 2>&1
    scp provision.sh ../files.tar stream@${IPLANG[$lang]}:~ > /dev/null 2>&1

  done
}
