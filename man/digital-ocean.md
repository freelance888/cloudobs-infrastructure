# Tutorial for Digital Ocean
This turorial can be used only on Linux or Mac. For Windows you have to use WSL 1 or 2. https://docs.microsoft.com/en-us/windows/wsl/install

1. Install doctl cli tools https://docs.digitalocean.com/reference/doctl/how-to/install/

2. Create API Token
3. Authenticate yourself with a project token
```
doctl auth init --context <NAME>
```

4. Generate SSH key for future VMs. Skip if done before.
```
ssh-keygen -t ed25519 -b 2048 -C service_automation -f $HOME/.ssh/service
ssh-add $HOME/.ssh/service
```
5. Upload ssh key to the hetzner project
```
doctl compute ssh-key create <key-name> --public-key=<PATH TO YOUR PUBLIC SSH KEY>
```

6. Add your ssh keys that should be provisioned to the `shared/files/userdata.yaml` file into user `stream` of the seciton `ssh_authorized_keys:`.

7. Create vms:
```
cd shared/scripts
./init.sh --cloud do --create-vm <VM INSTANCES COUNT>
./init.sh --cloud do --getip # Get list of ip from created vms
```

8. Add IP addresses from output to file `shared/scripts/ip.list`, just besides lang codes.

_You may add needed and comment not needed even in the middle of the list._

9. Place your `env` file content into `shared/files/env`. Example can be taken here https://github.com/ALLATRA-IT/cloudobs.git

10. Then activate provisioning
```
./init.sh --provision
```

11. Depending on VM power - wait for a 40-60 seconds

12. Now you can connect via obs socket,ssh, or vnc. You may use very handy filemanager `ranger` or `mc`.
