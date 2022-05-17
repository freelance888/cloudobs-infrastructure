#!/usr/bin/env bash

lang=$1
username="stream"

# OBS Config moving
tar -xf obs_config.tar -C /home/${username}/.config/
tar -xf ts_config.tar  -C /home/${username}/
tar -xf ts_client.tar  -C /home/${username}/
chown -R $username:$username /home/${username}

# Installing scripts for controlling obs
cd /opt/stream-services
git clone https://github.com/ALLATRA-IT/cloudobs.git
cd cloudobs/

# Setup env file
cp ~/env .env
sed -i -e '/LANG/d' .env
echo "LANG=$lang" >> .env

# Install dependencies
pip3 install -r requirements.txt
sudo systemctl daemon-reload

sudo systemctl enable common_service
sudo systemctl enable instance_service
sudo systemctl enable gdrive_sync

sudo systemctl start common_service
sudo systemctl start instance_service
sudo systemctl start gdrive_sync

# sudo systemctl restart common_service
# sudo systemctl restart instance_service
# sudo systemctl restart gdrive_sync

# systemctl status common_service
# systemctl status instance_service
# systemctl status gdrive_sync

# journalctl -u common_service.service
# journalctl -u instance_service.service
# journalctl -u gdrive_sync.service

# LAUNCH X SESSION
sudo nohup Xvfb :1 -ac -screen 0 1024x768x24 &
sleep 2
DISPLAY=:1 icewm &
# pulseaudio -D &
systemctl --user start pulseaudio.service
sleep 3
mkdir -p $HOME/.vnc
x11vnc -display :1 -storepasswd homeworld /home/$username/.vnc/passwd
x11vnc -display :1 -forever -rfbauth /home/$username/.vnc/passwd &

# Run Obs with websocket.
DISPLAY=:1 nohup obs &

# Run TeamSpeak
cd $HOME/ts
DISPLAY=:1 ./ts3client_runscript.sh "ts3server://ts.it-planeta.com?port=10335&channel=Translation/${lang}&nickname=${lang}_StreamListener" &
