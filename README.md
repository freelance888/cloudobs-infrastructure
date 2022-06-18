# Tutorial for Hetzner
Espesially for Hetzner cloud, because it is using `hcloud` cli tool.
If you are looking for multicloud version - please move [here](multicloud/)
This turorial can be used only on Linux or Mac. For Windows you have to use WSL 1 or 2. https://docs.microsoft.com/en-us/windows/wsl/install

1. Install hcloud cli tools https://github.com/hetznercloud/cli
or download binary https://github.com/hetznercloud/cli/releases

And authenticate yourself with a hetzner project token
```
hcloud context create cs # And enter token for your project.
hcloud context use cs
```

2. Generate SSH key for service purposes. Only this one key will be integrated into vms. Skip if done before.
```
ssh-keygen -t ed25519 -b 2048 -C service_automation -f $HOME/.ssh/service
ssh-add $HOME/.ssh/service
hcloud ssh-key create --name streaming_automation --public-key-from-file=$HOME/.ssh/service.pub
```

3. Add your ssh keys that should be provisioned into customuser to the `shared/files/userdata.yaml` file.
Also to the seciton `users/ssh_authorized_keys`. For both, `root` and `stream`.

4. Create vms:
```
cd shared/scripts
./init.sh --create-vm <VM INSTANCES COUNT>
./init.sh --getip # Get list of ip from created vms
```

5. Place your `env` file content into `shared/files/env`. Example can be taken here https://github.com/ALLATRA-IT/cloudobs.git

6. Add IP addresses from terraform output stdout besides lang codes, to file `shared/scripts/ip.list`.
You may add needed and comment not needed even in the middle of the list.

7. Upload files to vm's
```
./init.sh --upload-files
```

8. Then activate provisioning
```
./init.sh --provision
```

9. Depending on VM power - wait for a 40-60 seconds

10. Now you can connect via obs socket,ssh, or vnc. You may use very handy filemanager `ranger` or `mc`.

## Important Notices

### TeamSpeak3 default identity connection limits
Make sure your TeamSpeak identity *( that you are using for ts user )*, is allowed to connect to the same server multiple times.<br>
Otherwise teamspeak it will not connect to the server and target channel after applying `init.sh` and `provision.sh` scripts.<br>
**FIX:**
* Join server with identity you would like to upgrade with permission.
* Righ click on user and choose `Permissions/Client Permissions` (Avaialble only if you enabled `Advanced permission system` in `Options/Application`)
* Search for permission `i_client_max_clones_uid` and set it to `skip` checkmark. Now client with this identity can connect to server multiple times with no known limit.

----

## Deploy VMs from Hetzner UI
1. Choose instances amount and paste into SSH key your key and next value:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB4PmWN0Ipp8dllqr66Vf3TRoq7Sx+hf1QfD7fAGwIl0 vm-service
```
2. Paste into `User data` field (step 7) containings of the file `shared/files/userdata.yaml`
3. Press Create&Buy.
