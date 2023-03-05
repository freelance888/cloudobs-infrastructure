DO integration.
## List ip
doctl compute droplet list --no-header | tr -s ' ' | cut -d ' ' -f 3

## Create droplet
doctl compute droplet list --no-header | tr -s ' ' | cut -d ' ' -f 3

