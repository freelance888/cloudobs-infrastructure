#!/usr/bin/env bash
# Usage: execute script, it will create template of the config for ts serverquery api, go to ts client, create sq creds for you and fill it into the config.
# Port for sq usually 10011, server is the same u use with domain.
# server_id can be found with whoami command sent from telnet session after login (Read GetCurrentClients function body for details).
# Then just folloc tips, like creating file "expected" with list of langs you need to see.

CREDENTIALS_FILE="creds.cfg"
EXPECTED_FILE="expected"

function GetCredentials {
    if [ -e $CREDENTIALS_FILE ]; then
        source $CREDENTIALS_FILE
    else
        echo "Cannot find credentials file - $CREDENTIALS_FILE. Creating one."
        touch $CREDENTIALS_FILE
        printf "export SQUERY_URL=\"ip_or_domain_address_of_the_server\"\n"  >> $CREDENTIALS_FILE
        printf "export SQUERY_PORT=\"squery_port_obviosly)\"\n"              >> $CREDENTIALS_FILE
        printf "export SQUERY_SID=\"server_id\"\n"                           >> $CREDENTIALS_FILE
        printf "export SQUERY_USER=\"squery_username_generated_in_ts\"\n"    >> $CREDENTIALS_FILE
        printf "export SQUERY_PASSWORD=\"squery_password\"\n"                >> $CREDENTIALS_FILE
    fi
}

function CheckExistingLangs {
    if [ ! -e $EXPECTED_FILE ]; then
        echo "Please create file [ $EXPECTED_FILE ] and place here languages in a column you expect yo see"
        exit
    fi
}

function GetCurrentClients {
    echo " * Getting current clients with Synt name"
    expect -c '
        spawn telnet $env(SQUERY_URL) $env(SQUERY_PORT)
        send "login $env(SQUERY_USER) $env(SQUERY_PASSWORD)\r\n"
        send "use sid=$env(SQUERY_SID)\r\n"
        send "\r\n"
        send "clientfind pattern=Synt\r\n"
        send "\r\n"
		send "quit\r\n"
		interact
' > unexpected
  }


function Compare {
  echo " * Comparing connected clients and expected list. 100% match if output is empty."
  cat unexpected | grep clid | sed 's/|/\n/g' | sed 's/.*=//' | sed 's/_.*//' | cut -d' ' -f2 > existing
  echo "------------------"
  grep -F -x -v -f existing expected

}

GetCredentials
CheckExistingLangs
GetCurrentClients
Compare
