# Tutorial for Hetzner
Espesially for Hetzner cloud, because it is using `hcloud` cli tool.
If you are looking multicloud version - please go [here](multicloud/)
This turorial can be used only on Linux or Mac. For Windows you have to use WSL 1 or 2. https://docs.microsoft.com/en-us/windows/wsl/install

1. Install hcloud cli tools https://github.com/hetznercloud/cli
or download binary https://github.com/hetznercloud/cli/releases

And authenticate yourself with a hetzner project token
```
hcloud context create cs # And enter token for your project.
hcloud context use cs # optional if you are doing it first time.
```

2. Generate SSH key for future VMs. Skip if done before.
```
ssh-keygen -t ed25519 -b 2048 -C service_automation -f $HOME/.ssh/service
ssh-add $HOME/.ssh/service
```
3. Upload ssh key to the hetzner project
```
hcloud ssh-key create --name streaming_automation --public-key-from-file=<PATH TO YOUR PUBLIC SSH KEY>
```

4. Add your ssh keys that should be provisioned to the `shared/files/userdata.yaml` file into user `stream` of the seciton `ssh_authorized_keys:`.

5. Create vms:
```
cd shared/scripts
./init.sh --cloud do --create-vm <VM INSTANCES COUNT>
./init.sh --cloud do --getip # Get list of ip from created vms
```

6. Add IP addresses from output to file `shared/scripts/ip.list`, just besides lang codes.

_You may add needed and comment not needed even in the middle of the list._

7. Place your `env` file content into `shared/files/env`. Example can be taken here https://github.com/ALLATRA-IT/cloudobs.git

8. Then activate provisioning
```
./init.sh --provision
```

9. Depending on VM power - wait for a 40-60 seconds

10. Now you can connect via obs socket,ssh, or vnc. You may use very handy filemanager `ranger` or `mc`.

## Recording of audio streams from TeamSpeak
Use these flags for the `init.sh` script to proceed
```
  --start-rec # Starting recording using ffmpeg on pulse main output into the <lang>.wav file
  --stop-rec  # Gracefully kills ffmpeg process to stop recording
  --get-rec   # Creates dir with current date name and starts downloading process into it
  --del-rec   # Purges local recordings directory content and deletes remote recording file
```
