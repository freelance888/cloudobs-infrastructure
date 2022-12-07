#!/usr/bin/env bash
INSTANCES_COUNT=$2

source ip.list # Sources Lang - IP array
source functions/create_vm.sh
source functions/env_update.sh
source functions/get_ip.sh
source functions/get_status.sh
source functions/provision.sh
source functions/upload_files.sh
source functions/service_restart.sh
source functions/delete_all_vms.sh

# # Check if no args supplied
# if [ -z $* ]; then
#   echo "No options found!"
#   exit 1
# fi

while [ $# -gt 0 ] ; do
  case $1 in
    -c  | --create-vm)       create_vm $INSTANCES_COUNT && get_ip ;;
    -p  | --provision)       provision                            ;;
    -s  | --status)          get_status                           ;;
    -u  | --upload-files)    upload_files                         ;;
    -u2 | --upload-files2)   upload_files 2                       ;;
    -i  | --getip)           get_ip                               ;;
    -d  | --delete-all-vms)  delete_all_vms                       ;; # WIP
    # -e | --env-update)       env_update ;; # WIP
    # -r | --restart-services) service_restart ;; # WIP
    -h  | --help) echo " Available arguments:
  -c | --create-vm <COUNT>
  -p | --provision
  -s | --status
  -u | --uploadfiles
  -d | --delete-all-vms
  -u | --getip";;

  esac
  shift
done

# sendfiles provision launchapps envupdate restartservices getstatus
