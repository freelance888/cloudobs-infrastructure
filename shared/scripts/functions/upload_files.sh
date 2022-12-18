#!/usr/bin/env bash

function upload_files () {
  for lang in "${!IPLANG[@]}"
  do
    echo " * Sending files to [ $lang ] | ${IPLANG[$lang]}"
    ssh-keygen -R "${IPLANG[$lang]}" > /dev/null 2>&1 # Removes host from known_hosts to avoid long annoying message about changed keys.

    # scp ../files/services/* root@${IPLANG[$lang]}:/lib/systemd/system/ > /dev/null 2>&1 &
    cd ..
    COPYFILE_DISABLE=1 tar -cvf files.tar files > /dev/null 2>&1
    if [ $1 = 2 ]; then # Needed for upload ts config with a second identity .If first argument of the function is 2, arg, that was provided to it from init.sh script.
      # Renaming main config to unused and second to actual
      mv files/.ts3client files/old_tsconf
      mv files/.ts3client2 files/.ts3client
      COPYFILE_DISABLE=1 tar -cvf files.tar files > /dev/null 2>&1
    fi

    cd - > /dev/null 2>&1
    scp provision.sh ../files.tar sa.json stream@${IPLANG[$lang]}:~ > /dev/null 2>&1

  done
  rm -rf ../files.tar

  # Renaming it back
  mv files/.ts3client files/.ts3client2
  mv files/old_tsconf files/.ts3client

}
