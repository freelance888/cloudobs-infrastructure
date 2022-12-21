#!/usr/bin/env bash
INSTANCES_COUNT=$2

source ip.list # Sources Lang - IP array
source functions/create_vm.sh
source functions/delete_all_vms.sh
source functions/env_update.sh
source functions/get_ip.sh
source functions/get_status.sh
source functions/provision.sh
source functions/recording.sh
source functions/service_restart.sh

# # Check if no args supplied
# if [ -z $* ]; then
#   echo "No options found!"
#   exit 1
# fi

while [ $# -gt 0 ] ; do
  case $1 in
    -c | --create-vm)       create_vm $INSTANCES_COUNT && get_ip ;;
    -p | --provision)       upload_files && provision            ;;
    -s | --status)          get_status                           ;;
    -i | --getip)           get_ip                               ;;
    --start-rec)            start_rec                            ;;
    --stop-rec)             stop_rec                             ;;
    --get-rec)              get_rec                              ;;
    --del-rec)              del_rec                              ;;
    -d | --delete-all-vms)  delete_all_vms                       ;; # WIP
    # -e | --env-update)       env_update ;; # WIP
    # -r | --restart-services) service_restart ;; # WIP
    -h | --help) echo " Available arguments:
  -c | --create-vm <COUNT>
  -p | --provision
  -s | --status
  -u | --uploadfiles
  -d | --delete-all-vms
  -i | --getip
  --start-rec
  --stop-rec
  --get-rec
  --del-rec
  --help";;

  esac
  shift
done

# sendfiles provision launchapps envupdate restartservices getstatus
