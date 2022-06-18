#!/usr/bin/env bash

function get_ip () {
  hcloud server list -o columns=ipv4 -o noheader | sort
}
