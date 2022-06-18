# Streaming Automation Infrastructure

# Principle of work
* Terraform code creates VM on hetzner and uses `userdata.yaml` file installs dependencies and upgrades the system.
* Script `scripts/init.sh` being launched locally, copies all necessary files and script `scripts/provision.sh` to each remote host. Then it launching `scripts/provision.sh` remotely.
* Script `scripts/provision.sh` being called remotely on each vm - installs all custom apps with configs.
* Then it launching:
  * VNC server
  * TeamSpeak
  * OBS with websocket server
  * Three special services written on python3
---
# Usage

```
git clone git@github.com:ovitente/terraform-streaming-automation.git
cd terraform-streaming-automation/terraform
```
1. Generate SSH key for service purposes. Only this one key will be integrated into vms. Skip if done before.
```
ssh-keygen -t ed25519 -b 2048 -C service_automation -f ~/.ssh/service
ssh-add ~/.ssh/service
```
2. Copy `token_var.tf_sample` to `token_var.tf` and add hetzner token to it.
```
cp --no-preserve=xattr token_var.tf_sample token_var.tf
```
3. Change vms count int `variables.tf`
```
variable "instances_count" {
  description = "The amount of instances you need"
  default     = "3" # Like here
}
```
4. Add your ssh keys that should be provisioned into customuser to the `userdata.yaml` file. Seciton `users/ssh_authorized_keys`. For both users `root` and `stream`.
5. Create vms:
```
terraform init
terraform apply #--auto-approve
```
6. Place your `env` file content into `files/env`. Example can be taken here https://github.com/ALLATRA-IT/cloudobs.git
7. Add IP addresses from terraform output stdout besides lang codes, to file `scripts/ip.list`.
You may add needed and comment not needed even in the middle of the list.
8. Upload files to vm's
```
./init.sh --uploadfiles
```
9. Then activate provisioning
```
./init.sh --provision
```
10. Depending on VM power - wait for a 40-60 seconds
11. Now you can connect via obs socket,ssh, or vnc. You may use very handy filemanager `ranger` or `mc`.

## Important Notices

### TeamSpeak3 default identity connection limits
Make sure your TeamSpeak identity *( that you are using for ts user )*, is allowed to connect to the same server multiple times.<br>
Otherwise teamspeak it will not connect to the server and target channel after applying `init.sh` and `provision.sh` scripts.<br>
**FIX:**
* Join server with identity you would like to upgrade with permission.
* Righ click on user and choose `Permissions/Client Permissions` (Avaialble only if you enabled `Advanced permission system` in `Options/Application`)
* Search for permission `i_client_max_clones_uid` and set it to `skip` checkmark. Now client with this identity can connect to server multiple times with no known limit.
