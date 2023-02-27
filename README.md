# CloudOBS Infrastructure
**Tutorial to Deploy and provision VMs for stream automation.**

### List of supported clouds
**Please pick one**

[Hetzner](man/hetzner.md)<br>
[Digital Ocean](man/digital-ocean.md)

### Recording of audio streams from TeamSpeak
Use these flags for the `init.sh` script to proceed
```
  --start-rec # Starting recording using ffmpeg on pulse main output into the <lang>.wav file
  --stop-rec  # Gracefully kills ffmpeg process to stop recording
  --get-rec   # Creates dir with current date name and starts downloading process into it
  --del-rec   # Purges local recordings directory content and deletes remote recording file
```

### Important Notices

#### TeamSpeak3 default identity connection limits
Make sure your TeamSpeak identity *( that you are using for ts user )*, is allowed to connect to the same server multiple times.<br>
Otherwise teamspeak it will not connect to the server and target channel after applying `init.sh` and `provision.sh` scripts.<br>
**FIX:**
* Join server with identity you would like to upgrade with permission.
* Righ click on user and choose `Permissions/Client Permissions` (Avaialble only if you enabled `Advanced permission system` in `Options/Application`)
* Search for permission `i_client_max_clones_uid` and set it to `skip` checkmark. Now client with this identity can connect to server multiple times with no known limit.
