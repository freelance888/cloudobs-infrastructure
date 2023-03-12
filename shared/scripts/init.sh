#!/usr/bin/env bash

set -o nounset # Treat unset variables as an error and immediately exit
# set -o errexit # If a command fails exit the whole script

if [ "${DEBUG:-false}" = "true" ]; then
  set -x # Run the entire script in debug mode
fi

INSTANCES_COUNT=$3
CLOUD=""

source ip.list # Sources Lang - IP array
source functions/core.sh

function set_cloud () {
  local cloud_name=$1
  case $cloud_name in
    do)      source functions/digital-ocean.sh  ;;
    hetzner) source functions/hetzner.sh        ;;
    *) echo "Unsupported cloud name [ $cloud_name ]." && exit        ;;
  esac
}

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -o|--cloud)            set_cloud $2
      shift 2 ;;
    -c|--create-vm)        create_vm $2
      shift 2 ;;
    -p|--provision)        upload_files && provision
      shift 2 ;;
    -i|--getip)            get_ip
      shift 2 ;;
    -s|--status)           get_status
      shift 2 ;;
    -u | --uploadfiles)    upload_files
      shift 2 ;;
    -d | --delete-all-vms) delete_all_vms
      shift 2 ;;
    -s|--status)           get_status
      shift 2 ;;

    --start-rec)           start_rec
      shift 2 ;;
    --stop-rec)            stop_rec
      shift 2 ;;
    --get-rec)             get_rec
      shift 2 ;;
    --del-rec)             del_rec
      shift 2 ;;

    --)
      shift
      break ;;
    *)
      echo "Invalid option: $1" >&2
      exit 1 ;;
  esac
done
