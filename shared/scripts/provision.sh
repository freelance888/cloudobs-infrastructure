#!/usr/bin/env bash
rm /home/stream/PROVISION_STATUS
echo "IN PROGRESS" > /home/stream/PROVISION_STATUS
while [ ! -f /DONE ]
do
  sleep 2
done

lang=$1
username="stream"
# TODO: Add check to make sure script have paswordless sudo.

# Cleaning
kill -15 $(pgrep -f ts3client_linux_amd64)
sleep 15
pkill --signal 15 obs
rm -rf .ts3client .config/obs-studio

# OBS Config moving
mkdir -p /home/${username}/files
tar -xf files.tar --warning=no-unknown-keyword
sudo mv files/services/* /lib/systemd/system/
mv -f files/configs/.ts3client $HOME
mv -f files/configs/obs-studio $HOME/.config/

sudo chown -R $username:$username /home/${username}

# Setup env file
cd /opt/stream-services/cloudobs
cp ~/files/env .env
sed -i -e '/LANG/d' .env
echo "LANG=$lang" >> .env

sudo systemctl daemon-reload

sudo systemctl enable instance_service
sudo systemctl enable gdrive_sync
sudo systemctl enable obs
sudo systemctl enable teamspeak

sudo systemctl start instance_service
sudo systemctl start gdrive_sync

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

# sudo systemctl start obs
# sudo systemctl start teamspeak

# Run Obs with websocket.
DISPLAY=:1 nohup obs &

# Run TeamSpeak
cd $HOME/ts
DISPLAY=:1 ./ts3client_runscript.sh "ts3server://ts.it-planeta.com?port=10335&channel=Translation/${lang}&nickname=${lang}_Synthetic_StreamListener" > /dev/null 2>&1 &

rm /home/stream/PROVISION_STATUS
echo "DONE" > /home/stream/PROVISION_STATUS
